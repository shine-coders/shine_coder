# shinecoder

[![Package Version](https://img.shields.io/hexpm/v/shine_coder)](https://hex.pm/packages/shine_coder)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/shine_coder/)

Parse, encode, build, and analyze WebAssembly modules using `shine_coder`! This library was born out of
a need to conquer and understand the new WebAssembly GC specification, so all the functions in this library
are designed to follow the specification as closely as possible.

Currently this project is in an Alpha state and the developer consuming this library is required to understand
the structure of WASM modules in order to build them. For instance, creating a module with a simple `add`
function requires the following steps:

```rs
// 1. Make all the indexes up front. These return a result because all indexes
//    must be valid unsigned 32 bit integers.
let assert Ok(type_idx_0) = module.type_idx(0)
let assert Ok(local_idx_0) = module.local_idx(0)
let assert Ok(local_idx_1) = module.local_idx(1)
let assert Ok(func_idx_0) = module.func_idx(0)

let assert Ok(add_module) =
  // 2. Create the module
  module.new()
  // 3. Define the function type, store it at index 0
  |> module.add_type(
    rec_type.func_type([val_type.i32, val_type.i32], [val_type.i32]),
  )
  // 4. Tell the wasm module that "function 0" has the type of "type 0"
  |> module.add_function_type(type_idx_0)
  // 5. Add the body of the function to the module at function index 0
  |> module.add_code(
    // 5.a Function parameters and locals must be defined here: [..parameters, ..locals]
    [val_type.i32, val_type.i32],
    // 5.b Create an expression for the function body
    expression.new()
      |> local.get(local_idx_0)
      |> local.get(local_idx_1)
      |> i32.add
      // 5.c Validate the expression nesting, and return an `Expr`
      |> expression.end_unwrap(),
  )
  // 6. Finally, export the function at "function index 0" calling it "add"
  |> module.export_func("add", func_idx_0)
  |> module.encode

let assert Ok(Nil) = simplifile.write_bits("shinecoder.wasm", add_module)
```

Visualizing the output using the text format looks like this:

```wat
(module
  (type (;0;) (func (param i32 i32) (result i32)))
  (func (;0;) (type 0) (param i32 i32) (result i32)
    (local i32 i32)
    local.get 0
    local.get 1
    i32.add)
  (export "add" (func 0)))
```

In the future, this will become more developer friendly with a nice high level api which handles the
intricacies of building WASM modules.

## Goals

Some of these goals are personal, 

1. Create a library that makes WebAssembly accessible to the Gleam package ecosystem
2. Be compatible with JavaScript and Gleam Targets
3. Validate and Host WASM modules in a Spec Compliant way (not necessarily with performance in mind)
4. (Personal) - Conquer the WebAssembly GC specification, validation, execution, and building
5. Make a developer friendly interface for generating abstract WASM modules, manipulating code, and compile them to WASM binaries