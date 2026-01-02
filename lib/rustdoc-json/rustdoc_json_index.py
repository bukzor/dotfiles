#!/usr/bin/env python3
"""Build searchable index from rustdoc JSON.

Input: parsed rustdoc JSON (dict)
Output: list of (id, name_ast) where name_ast is nested lists of strings
"""

from typing import Any

# Type aliases for clarity
type Json = dict[str, Any]
type Ast = list[Ast]  # nested lists of strings


def format_type(ty: Json) -> Ast:
    """Convert rustdoc type JSON to AST."""
    match ty:
        case {"resolved_path": {"path": path, "args": {"angle_bracketed": {"args": args}}}} if args:
            return [path, ["args"] + [format_arg(a) for a in args]]

        case {"resolved_path": {"path": path}}:
            return [path]

        case {"primitive": p}:
            return [p]

        case {"generic": g}:
            return [g]

        case {"borrowed_ref": {"lifetime": lt, "is_mutable": True, "type": inner}}:
            return [f"&{lt} mut", format_type(inner)]

        case {"borrowed_ref": {"lifetime": lt, "type": inner}}:
            return [f"&{lt}", format_type(inner)]

        case {"borrowed_ref": {"is_mutable": True, "type": inner}}:
            return ["&mut", format_type(inner)]

        case {"borrowed_ref": {"type": inner}}:
            return ["&", format_type(inner)]

        case {"slice": inner}:
            return ["slice", format_type(inner)]

        case {"array": {"type": inner, "len": length}}:
            return ["array", format_type(inner), length]

        case {"tuple": items}:
            return ["tuple"] + [format_type(t) for t in items]

        case {"qualified_path": {"name": name, "self_type": self_ty, "trait": {"path": trait_path, "args": {"angle_bracketed": {"args": trait_args}}}}} if trait_args:
            # <SelfType as Trait<Args>>::Name
            return ["qualified", format_type(self_ty), [trait_path, ["args"] + [format_arg(a) for a in trait_args]], name]

        case {"qualified_path": {"name": name, "self_type": self_ty, "trait": {"path": trait_path}}}:
            # <SelfType as Trait>::Name
            return ["qualified", format_type(self_ty), [trait_path], name]

        case _:
            raise ValueError(f"Unknown type variant: {list(ty.keys())}")


def format_arg(arg: Json) -> Ast:
    """Convert a generic argument to AST."""
    match arg:
        case {"lifetime": lt}:
            return [lt]
        case {"type": t}:
            return format_type(t)
        case {"primitive": p}:
            return [p]
        case {"generic": g}:
            return [g]
        case _:
            raise ValueError(f"Unknown arg variant: {list(arg.keys())}")


def format_trait(trait: Json, paths: Json) -> Ast:
    """Convert trait reference to AST, using full path for disambiguation."""
    trait_id = trait["id"]
    path_entry = paths[str(trait_id)]
    full_path = "::".join(path_entry["path"])

    match trait:
        case {"args": {"angle_bracketed": {"args": args}}} if args:
            return [full_path, ["args"] + [format_arg(a) for a in args]]
        case _:
            return [full_path]


def format_impl(impl: Json, idx: Json, paths: Json) -> list[Ast]:
    """Convert impl to list of ASTs (one per item)."""
    generics = [p["name"] for p in impl["generics"]["params"]]
    trait_ast = format_trait(impl["trait"], paths) if impl["trait"] is not None else None
    for_ast = format_type(impl["for"])

    results = []
    for item_id in impl["items"]:
        item_name = idx[str(item_id)]["name"]

        ast: Ast = ["impl"]
        if generics:
            ast.append(["generics"] + generics)
        if trait_ast:
            ast.append(["trait"] + trait_ast)
        ast.append(["for"] + for_ast)
        ast.append(["item", item_name])

        results.append(ast)

    return results


def index_rustdoc(data: Json) -> list[tuple[str, Ast]]:
    """Build index from rustdoc JSON."""
    idx = data["index"]
    paths = data["paths"]
    results = []

    for id_str, entry in idx.items():
        inner = entry["inner"]
        if "impl" in inner:
            for ast in format_impl(inner["impl"], idx, paths):
                results.append((id_str, ast))

    return results


def ast_to_string(ast: Ast) -> str:
    """Convert AST to readable string."""

    def type_to_str(t: Ast) -> str:
        match t:
            case [head, inner] if isinstance(head, str) and head.startswith("&"):
                return f"{head} {type_to_str(inner)}"
            case ["slice", inner]:
                return f"[{type_to_str(inner)}]"
            case ["array", inner, length]:
                return f"[{type_to_str(inner)}; {length}]"
            case ["tuple", *items]:
                return "(" + ", ".join(type_to_str(i) for i in items) + ")"
            case ["qualified", self_ty, trait_ty, name]:
                return f"<{type_to_str(self_ty)} as {type_to_str(trait_ty)}>::{name}"
            case ["args", *args]:
                return "<" + ", ".join(type_to_str(a) for a in args) + ">"
            case [name, ["args", *args]]:
                return name + "<" + ", ".join(type_to_str(a) for a in args) + ">"
            case [name]:
                return name
            case _:
                raise ValueError(f"Unknown AST in type_to_str: {t}")

    match ast:
        case ["impl", *rest]:
            parts = ["impl"]
            for sub in rest:
                match sub:
                    case ["generics", *gs]:
                        parts.append("<" + ", ".join(gs) + ">")
                    case ["trait", *t]:
                        parts.append(" " + type_to_str(t) + " for")
                    case ["for", *f]:
                        parts.append(" " + type_to_str(f))
                    case ["item", name]:
                        parts.append("::" + name)
                    case _:
                        raise ValueError(f"Unknown impl sub-AST: {sub}")
            return "".join(parts)
        case _:
            raise ValueError(f"Unknown AST in ast_to_string: {ast}")


if __name__ == "__main__":
    import json
    import sys

    data = json.load(sys.stdin)
    for id_str, ast in index_rustdoc(data):
        print(f"{id_str} {ast_to_string(ast)}")
