"""Tests for rustdoc_json_index.py

Covers cases that failed in the jq implementation.
"""

import pytest

from rustdoc_json_index import format_type, format_arg, format_trait, format_impl, ast_to_string


class TestFormatType:
    """Test type formatting - these were the main failure points in jq."""

    def test_resolved_path_simple(self):
        ty = {"resolved_path": {"path": "String", "id": 1, "args": None}}
        assert format_type(ty) == ["String"]

    def test_resolved_path_with_args(self):
        ty = {
            "resolved_path": {
                "path": "Vec",
                "id": 1,
                "args": {
                    "angle_bracketed": {
                        "args": [{"type": {"primitive": "u8"}}],
                        "constraints": [],
                    }
                },
            }
        }
        assert format_type(ty) == ["Vec", ["args", ["u8"]]]

    def test_primitive(self):
        assert format_type({"primitive": "str"}) == ["str"]
        assert format_type({"primitive": "u8"}) == ["u8"]

    def test_generic(self):
        assert format_type({"generic": "T"}) == ["T"]

    def test_borrowed_ref_with_lifetime(self):
        """This failed in early jq version."""
        ty = {
            "borrowed_ref": {
                "lifetime": "'a",
                "is_mutable": False,
                "type": {"primitive": "str"},
            }
        }
        assert format_type(ty) == ["&", "'a", ["str"]]

    def test_borrowed_ref_mutable(self):
        ty = {
            "borrowed_ref": {
                "lifetime": "'a",
                "is_mutable": True,
                "type": {"primitive": "str"},
            }
        }
        assert format_type(ty) == ["&", "'a", "mut", ["str"]]

    def test_borrowed_ref_no_lifetime(self):
        """Lifetime can be null - fixed in 77209f0."""
        ty = {
            "borrowed_ref": {
                "lifetime": None,
                "is_mutable": False,
                "type": {"primitive": "str"},
            }
        }
        assert format_type(ty) == ["&", ["str"]]

    def test_slice(self):
        """This was missing in early jq version."""
        ty = {"slice": {"primitive": "u8"}}
        assert format_type(ty) == ["slice", ["u8"]]

    def test_array(self):
        """This was missing in jq version."""
        ty = {"array": {"type": {"primitive": "u8"}, "len": "32"}}
        assert format_type(ty) == ["array", ["u8"], "32"]

    def test_tuple(self):
        """This was missing in jq version."""
        ty = {"tuple": [{"primitive": "u8"}, {"primitive": "u16"}]}
        assert format_type(ty) == ["tuple", ["u8"], ["u16"]]

    def test_qualified_path_simple(self):
        """<SelfType as Trait>::Name"""
        ty = {
            "qualified_path": {
                "name": "Item",
                "self_type": {"generic": "I"},
                "trait": {"path": "Iterator", "id": 1, "args": None},
            }
        }
        assert format_type(ty) == ["qualified", ["I"], ["Iterator"], "Item"]

    def test_qualified_path_with_trait_args(self):
        """<SelfType as Trait<Args>>::Name"""
        ty = {
            "qualified_path": {
                "name": "Output",
                "self_type": {"generic": "F"},
                "trait": {
                    "path": "FnOnce",
                    "id": 1,
                    "args": {
                        "angle_bracketed": {
                            "args": [{"type": {"tuple": [{"primitive": "u8"}]}}],
                            "constraints": [],
                        }
                    },
                },
            }
        }
        assert format_type(ty) == [
            "qualified",
            ["F"],
            ["FnOnce", ["args", ["tuple", ["u8"]]]],
            "Output",
        ]

    def test_unknown_variant_raises(self):
        """Unknown variants should raise with their keys for debugging."""
        ty = {"some_new_variant": {"foo": "bar"}}
        with pytest.raises(ValueError, match="some_new_variant"):
            format_type(ty)


class TestFormatArg:
    def test_lifetime(self):
        assert format_arg({"lifetime": "'a"}) == ["'a"]

    def test_type(self):
        assert format_arg({"type": {"primitive": "u8"}}) == ["u8"]

    def test_generic(self):
        assert format_arg({"generic": "T"}) == ["T"]


class TestFormatTrait:
    def test_simple_trait(self):
        """Uses full path from paths table."""
        trait = {"path": "Clone", "id": 1, "args": None}
        paths = {"1": {"path": ["std", "clone", "Clone"], "kind": "trait"}}
        assert format_trait(trait, paths) == ["std::clone::Clone"]

    def test_trait_with_args(self):
        """From<T> was showing as just 'From' in early jq version."""
        trait = {
            "path": "From",
            "id": 1,
            "args": {
                "angle_bracketed": {
                    "args": [{"type": {"generic": "T"}}],
                    "constraints": [],
                }
            },
        }
        paths = {"1": {"path": ["std", "convert", "From"], "kind": "trait"}}
        assert format_trait(trait, paths) == ["std::convert::From", ["args", ["T"]]]

    def test_trait_path_disambiguates(self):
        """Two traits with same short name but different full paths."""
        trait1 = {"path": "Error", "id": 215, "args": None}
        trait2 = {"path": "Error", "id": 218, "args": None}
        paths = {
            "215": {"path": ["serde", "de", "Error"], "kind": "trait"},
            "218": {"path": ["serde", "ser", "Error"], "kind": "trait"},
        }
        assert format_trait(trait1, paths) == ["serde::de::Error"]
        assert format_trait(trait2, paths) == ["serde::ser::Error"]

    def test_missing_path_raises(self):
        """Missing path entry should raise."""
        trait = {"path": "Clone", "id": 999, "args": None}
        paths = {}
        with pytest.raises(KeyError):
            format_trait(trait, paths)


class TestFormatImpl:
    def test_inherent_impl(self):
        """Inherent impl (no trait) - was showing double space in jq."""
        impl = {
            "generics": {"params": [], "where_predicates": []},
            "trait": None,
            "for": {"resolved_path": {"path": "Foo", "id": 1, "args": None}},
            "items": [100],
        }
        idx = {"100": {"name": "new"}}
        paths = {}
        result = format_impl(impl, idx, paths)
        assert result == [[
            "impl",
            ["for", "Foo"],
            ["item", "new"],
        ]]

    def test_trait_impl(self):
        impl = {
            "generics": {"params": [], "where_predicates": []},
            "trait": {"path": "Clone", "id": 2, "args": None},
            "for": {"resolved_path": {"path": "Foo", "id": 1, "args": None}},
            "items": [100],
        }
        idx = {"100": {"name": "clone"}}
        paths = {"2": {"path": ["std", "clone", "Clone"], "kind": "trait"}}
        result = format_impl(impl, idx, paths)
        assert result == [[
            "impl",
            ["trait", "std::clone::Clone"],
            ["for", "Foo"],
            ["item", "clone"],
        ]]

    def test_impl_with_generics(self):
        impl = {
            "generics": {
                "params": [{"name": "T", "kind": {"type": {}}}],
                "where_predicates": [],
            },
            "trait": {"path": "From", "id": 2, "args": {
                "angle_bracketed": {"args": [{"type": {"generic": "T"}}], "constraints": []}
            }},
            "for": {"resolved_path": {"path": "Error", "id": 1, "args": None}},
            "items": [100],
        }
        idx = {"100": {"name": "from"}}
        paths = {"2": {"path": ["std", "convert", "From"], "kind": "trait"}}
        result = format_impl(impl, idx, paths)
        assert result == [[
            "impl",
            ["generics", "T"],
            ["trait", "std::convert::From", ["args", ["T"]]],
            ["for", "Error"],
            ["item", "from"],
        ]]

    def test_splatted_items(self):
        """Multiple items should produce multiple ASTs with same impl prefix."""
        impl = {
            "generics": {"params": [], "where_predicates": []},
            "trait": None,
            "for": {"resolved_path": {"path": "Foo", "id": 1, "args": None}},
            "items": [100, 101, 102],
        }
        idx = {
            "100": {"name": "new"},
            "101": {"name": "build"},
            "102": {"name": "run"},
        }
        paths = {}
        result = format_impl(impl, idx, paths)
        assert len(result) == 3
        assert result[0][-1] == ["item", "new"]
        assert result[1][-1] == ["item", "build"]
        assert result[2][-1] == ["item", "run"]


class TestAstToString:
    def test_simple_impl(self):
        ast = ["impl", ["for", "Foo"], ["item", "new"]]
        assert ast_to_string(ast) == "impl Foo::new"

    def test_trait_impl(self):
        ast = ["impl", ["trait", "std::clone::Clone"], ["for", "Foo"], ["item", "clone"]]
        assert ast_to_string(ast) == "impl std::clone::Clone for Foo::clone"

    def test_impl_with_generics(self):
        ast = [
            "impl",
            ["generics", "T"],
            ["trait", "std::convert::From", ["args", ["T"]]],
            ["for", "Error"],
            ["item", "from"],
        ]
        assert ast_to_string(ast) == "impl<T> std::convert::From<T> for Error::from"

    def test_trait_path_in_output(self):
        """Full trait paths should appear in string output for disambiguation."""
        ast1 = ["impl", ["trait", "serde::de::Error"], ["for", "Error"], ["item", "custom"]]
        ast2 = ["impl", ["trait", "serde::ser::Error"], ["for", "Error"], ["item", "custom"]]
        assert ast_to_string(ast1) == "impl serde::de::Error for Error::custom"
        assert ast_to_string(ast2) == "impl serde::ser::Error for Error::custom"
        assert ast_to_string(ast1) != ast_to_string(ast2)

    def test_borrowed_ref(self):
        ast = ["impl", ["for", "&", "'a", ["str"]], ["item", "foo"]]
        assert ast_to_string(ast) == "impl &'a str::foo"

    def test_slice(self):
        ast = ["impl", ["for", "slice", ["u8"]], ["item", "foo"]]
        assert ast_to_string(ast) == "impl [u8]::foo"

    def test_array(self):
        ast = ["impl", ["for", "array", ["u8"], "32"], ["item", "foo"]]
        assert ast_to_string(ast) == "impl [u8; 32]::foo"

    def test_tuple(self):
        ast = ["impl", ["for", "tuple", ["u8"], ["u16"]], ["item", "foo"]]
        assert ast_to_string(ast) == "impl (u8, u16)::foo"

    def test_qualified_path(self):
        ast = ["impl", ["for", "qualified", ["I"], ["Iterator"], "Item"], ["item", "foo"]]
        assert ast_to_string(ast) == "impl <I as Iterator>::Item::foo"
