import gleam/option.{type Option, None}
import internal/finger_tree.{type FingerTree}
import internal/structure/numbers.{type U32}
import internal/structure/types.{
  type Code, type Data, type Elem, type Export, type FuncIDX, type Global,
  type Import, type MemType, type RecType, type Table, type TypeIDX,
}

/// This type represents a BinaryModule, which is a structural representation of a WebAssembly module,
/// rather than a conceptual one. This type is used internally to be an encoding/decoding interface
/// for web assembly targets.
pub type BinaryModule {
  BinaryModule(
    custom_0: Option(FingerTree(CustomSection)),
    types: Option(TypeSection),
    custom_1: Option(FingerTree(CustomSection)),
    imports: Option(ImportSection),
    custom_2: Option(FingerTree(CustomSection)),
    functions: Option(FunctionSection),
    custom_3: Option(FingerTree(CustomSection)),
    tables: Option(TableSection),
    custom_4: Option(FingerTree(CustomSection)),
    memories: Option(MemorySection),
    custom_5: Option(FingerTree(CustomSection)),
    globals: Option(GlobalSection),
    custom_6: Option(FingerTree(CustomSection)),
    exports: Option(ExportSection),
    custom_7: Option(FingerTree(CustomSection)),
    start: Option(StartSection),
    custom_8: Option(FingerTree(CustomSection)),
    elements: Option(ElementSection),
    custom_9: Option(FingerTree(CustomSection)),
    code: Option(CodeSection),
    custom_10: Option(FingerTree(CustomSection)),
    data: Option(DataSection),
    custom_11: Option(FingerTree(CustomSection)),
    data_count: Option(DataCountSection),
    custom_12: Option(FingerTree(CustomSection)),
  )
}

/// This method returns a new BinaryModule
pub fn binary_module_new() {
  BinaryModule(
    custom_0: None,
    types: None,
    custom_1: None,
    imports: None,
    custom_2: None,
    functions: None,
    custom_3: None,
    tables: None,
    custom_4: None,
    memories: None,
    custom_5: None,
    globals: None,
    custom_6: None,
    exports: None,
    custom_7: None,
    start: None,
    custom_8: None,
    elements: None,
    custom_9: None,
    code: None,
    custom_10: None,
    data: None,
    custom_11: None,
    data_count: None,
    custom_12: None,
  )
}

/// WebAssembly allows for unlimited custom sections that can be added between other sections
/// of a module. Each one is represented by a name, and a binary payload.
pub type CustomSection {
  CustomSection(name: String, data: BitArray)
}

/// The WebAssembly type section contains a list of type declarations, all indexed by their
/// recursive type group. This allows for a compact storage of this type information, and when
/// "unrolled", these types become the type index for validation and execution.
pub type TypeSection {
  TypeSection(types: FingerTree(RecType))
}

/// WebAssembly modules can import functions, tables, memories, and globals. This section
/// contains a list of those imports to describe what the module expects to use from
/// the host.
pub type ImportSection {
  ImportSection(imports: FingerTree(Import))
}

/// The WebAssembly function section is not a list of function declarations. Rather, it
/// contains a list of type indexes that are type IDs for the functions in the module.
/// In order for a WebAssembly module to be valid, each type index must refer to a type
/// that expands to a function composite type.
pub type FunctionSection {
  FunctionSection(funcs: FingerTree(TypeIDX))
}

/// WebAssembly modules can declare tables which are pre-allocated arrays of values that
/// contain refrences to other WebAssembly objects. Each table is defined by a RefrenceType
/// (which is a classification of object) that can be nullable and a limit that describes
/// how many can exist within.
pub type TableSection {
  TableSection(tables: FingerTree(Table))
}

/// WebAssembly modules can declare linear memories which represent conceptual linear memory
/// segments that can be used by the module for memory allocation and other operations.
pub type MemorySection {
  MemorySection(mts: FingerTree(MemType))
}

/// WebAssembly modules can declare global values which can be mutable and accessible from
/// both the host and the WebAssembly module. Each global is defined by the ValueType it
/// can hold, it's mutabliity, and an initial value.
pub type GlobalSection {
  GlobalSection(globals: FingerTree(Global))
}

/// WebAssembly modules can export functions, tables, memories, and globals. This section
/// simply describes the set of exports in the module defined by a name, an export type, and
/// a corresponding index to the other section containing that export.
pub type ExportSection {
  ExportSection(exports: FingerTree(Export))
}

/// The WebAssembly start section specifies the index of the function to be called when the
/// module is instantiated.
pub type StartSection {
  StartSection(start: FuncIDX)
}

/// In web assembly, tables can be initialized with element segments. Each one of these segments
/// contains a list of RefType values that can either be initialized when the module is instantiated (active),
/// preallocated for later use (passive), or declared up front for wasm engine optimization (declarative).
/// 
/// Typically, modules only have active or passive element segments, and are most commonly used for
/// function refrences for indirect function calls.
pub type ElementSection {
  ElementSection(elems: FingerTree(Elem))
}

/// WebAssembly modules can declare callable functions called "Code"s which define the shape
/// of the function described in the function section. Each "Code" has a list of parameters
/// defined by their valtypes, a list of locals defined by their valtypes, and an expression
/// of operations that represent the body of the function. Every body is terminated by an
/// 0x0B "end" byte instruction to signify the end of the expression.
pub type CodeSection {
  CodeSection(codes: FingerTree(Code))
}

/// WebAssembly modules can declare linear data segments which are pre-allocated byte arrays
/// of data that can either be instantiated and written into the Module's linear memory, or
/// declared as static segment for later use.
pub type DataSection {
  DataSection(data: FingerTree(Data))
}

/// The WebAssembly data count section simply contains the number of data segments in the
/// module and can be used to validate the shape of the data section itself.
pub type DataCountSection {
  DataCountSection(count: U32)
}
