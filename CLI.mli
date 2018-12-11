(** {4 Exceptions} *)

exception Not_an_int of string
exception Not_a_string of string
exception Not_a_float of string
exception Not_a_bool of string
exception No_param_for_option of string
exception More_than_once of string
exception Option_is_mandatory of string
exception Duplicate_in_specification of string
exception Unused_options of string

(** Sys.argv as a list *)
type args = string list

(** all accepted strings meaning the same option *)
type option_strings = string list

(** {4 Initialization} *)

(** Call [init] before using any of the other funtions
    (unless you really know what you are doing).
    [let argc, args = CLI.init () in ...]
    will compute [argc] and transform Sys.argv into the string list [args]. *)
val init: unit -> int * args

(** {4 Finalization} *)

(** You can (but you are not forced to) call [finalize] in case options
    parsing is finished. Meaning, the program will not try to process
    command line options anymore.
    [finalize] will enforce that there are no unused options left
    on the command line.
    In case there are some options left unused on the command line,
    [finalize] will raise an [Unused_options] exception listing them all. *)
val finalize: unit -> unit

(** {4 Parse mandatory options} *)

(** read a mandatory int from the command line *)
val get_int: option_strings -> args -> int

(** read a mandatory char from the command line *)
val get_char: option_strings -> args -> char

(** read a mandatory string from the command line *)
val get_string: option_strings -> args -> string

(** read a mandatory float from the command line *)
val get_float: option_strings -> args -> float

(** undocumented *)
val get_bool: option_strings -> args -> bool

(** return true if flag was present on the command line,
    false otherwise *)
val get_set_bool: option_strings -> args -> bool

(** return false if flag was present on the command line,
    true otherwise *)
val get_reset_bool: option_strings -> args -> bool

(** {4 Parse optional options} *)

(** read an optional int from the command line *)
val get_int_opt: option_strings -> args -> int option

(** read an optional char from the command line *)
val get_char_opt: option_strings -> args -> char option

(** read an optional string from the command line *)
val get_string_opt: option_strings -> args -> string option

(** read an optional float from the command line *)
val get_float_opt: option_strings -> args -> float option

(** undocumented *)
val get_bool_opt: option_strings -> args -> bool option

(** {4 Parse optional options with a default value} *)

(** read an optional int from the command line, or use the provided default
    if option was not seen on the command line *)
val get_int_def: option_strings -> args -> int -> int

(** read an optional string from the command line, or use the provided default
    if option was not seen on the command line *)
val get_string_def: option_strings -> args -> string -> string

(** read an optional char from the command line, or use the provided default
    if option was not seen on the command line *)
val get_char_def: option_strings -> args -> char -> char

(** read an optional float from the command line, or use the provided default
    if option was not seen on the command line *)
val get_float_def: option_strings -> args -> float -> float

(** undocumented *)
val get_bool_def: option_strings -> args -> bool -> bool
