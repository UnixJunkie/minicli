(** {4 Exceptions} *)

exception Not_an_int of string
exception Not_a_string of string
exception Not_a_float of string
exception Not_a_bool of string
exception No_param_for_option of string
exception More_than_once of string
exception Option_is_mandatory of string
exception Duplicate_in_specification of string

(** {4 Initialization} *)

(** Call [init] before using any of the other funtions
    (unless you really know what you are doing).
    [let argc, args = CLI.init () in ...]
    will compute [argc] and transform Sys.argv into the string list [args]. *)
val init: unit -> int * string list

(** {4 Parse mandatory options} *)

(** read a mandatory int from the command line *)
val get_int : string list -> string list -> int

(** read a mandatory char from the command line *)
val get_char : string list -> string list -> char

(** read a mandatory string from the command line *)
val get_string : string list -> string list -> string

(** read a mandatory float from the command line *)
val get_float : string list -> string list -> float

(** undocumented *)
val get_bool : string list -> string list -> bool

(** return true if flag was present on the command line,
    false otherwise *)
val get_set_bool : string list -> string list -> bool

(** return false if flag was present on the command line,
    true otherwise *)
val get_reset_bool : string list -> string list -> bool

(** {4 Parse optional options} *)

(** read an optional int from the command line *)
val get_int_opt : string list -> string list -> int option

(** read an optional char from the command line *)
val get_char_opt : string list -> string list -> char option

(** read an optional string from the command line *)
val get_string_opt : string list -> string list -> string option

(** read an optional float from the command line *)
val get_float_opt : string list -> string list -> float option

(** undocumented *)
val get_bool_opt : string list -> string list -> bool option

(** {4 Parse optional options with a default value} *)

(** read an optional int from the command line, or use the provided default
    if option was not seen on the command line *)
val get_int_def : string list -> string list -> int -> int

(** read an optional string from the command line, or use the provided default
    if option was not seen on the command line *)
val get_string_def : string list -> string list -> string -> string

(** read an optional char from the command line, or use the provided default
    if option was not seen on the command line *)
val get_char_def : string list -> string list -> char -> char

(** read an optional float from the command line, or use the provided default
    if option was not seen on the command line *)
val get_float_def : string list -> string list -> float -> float

(** undocumented *)
val get_bool_def : string list -> string list -> bool -> bool
