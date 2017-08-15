
exception Not_an_int of string
exception Not_a_string of string
exception Not_a_float of string
exception Not_a_bool of string
exception No_param_for_option of string
exception More_than_once of string
exception Option_is_mandatory of string
exception Duplicate_in_specification of string

(* For mandatory options *)

val get_int : string list -> string list -> int
val get_string : string list -> string list -> string
val get_float : string list -> string list -> float
val get_bool : string list -> string list -> bool
val get_set_bool : string list -> string list -> bool
val get_reset_bool : string list -> string list -> bool

(* For optional options *)
      
val get_int_opt : string list -> string list -> int option
val get_string_opt : string list -> string list -> string option
val get_float_opt : string list -> string list -> float option
val get_bool_opt : string list -> string list -> bool option
