# LSP

## Description

Interact with Language Server Protocol (LSP) servers to get code intelligence features.

Supported operations:
- goToDefinition: Find where a symbol is defined
- findReferences: Find all references to a symbol
- hover: Get hover information (documentation, type info) for a symbol
- documentSymbol: Get all symbols (functions, classes, variables) in a document
- workspaceSymbol: Search for symbols across the entire workspace

All operations require:
- filePath: The file to operate on
- line: The line number (0-indexed)
- character: The character offset (0-indexed) on the line

Note: LSP servers must be configured for the file type. If no server is available, an error will be returned.

## Full Instructions

Interact with Language Server Protocol (LSP) servers to get code intelligence features.

Supported operations:
- goToDefinition: Find where a symbol is defined
- findReferences: Find all references to a symbol
- hover: Get hover information (documentation, type info) for a symbol
- documentSymbol: Get all symbols (functions, classes, variables) in a document
- workspaceSymbol: Search for symbols across the entire workspace

All operations require:
- filePath: The file to operate on
- line: The line number (0-indexed)
- character: The character offset (0-indexed) on the line

Note: LSP servers must be configured for the file type. If no server is available, an error will be returned.
