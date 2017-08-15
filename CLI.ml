
module Ht = Hashtbl
module L = List

(* options provided by the user on the CLI are called 'raw';
   they become 'processed' afterwards *)

module Processed_option = struct

  type t = S of string
         | I of int
         | F of float
         | B of bool

  let to_string = function
    | S s -> "S: " ^ s
    | I i -> "I: " ^ (string_of_int i)
    | F f -> "F: " ^ (string_of_float f)
    | B b -> "B: " ^ (string_of_bool b)

end

exception Not_an_int of string
exception Not_a_string of string
exception Not_a_float of string
exception Not_a_bool of string

module Raw_option = struct

  type t = String of string
         | Int of string
         | Float of string
         | Bool of string

  let to_string = function
    | String s
    | Int s
    | Float s
    | Bool s -> s

  let read_float s =
    try Scanf.sscanf s "%f" (fun x -> x)
    with _ -> raise (Not_a_float s)

  let read_int s =
    try Scanf.sscanf s "%d" (fun x -> x)
    with _ -> raise (Not_an_int s)

  let read_bool = function
    | "on" | "true" -> true
    | "off" | "false" -> false
    | other -> raise (Not_a_bool other)

  let process x y =
    Processed_option.(match x with
        | String _ -> S y
        | Int _ -> I (read_int y)
        | Float _ -> F (read_float y)
        | Bool _ -> B (read_bool y)
      )

end

exception No_param_for_option of string

let rec get_param (kwd: Raw_option.t) (args: string list): Processed_option.t =
  match args with
  | [] -> assert(false) (* case caught in match_kwd *)
  | curr :: rest ->
    let keyword = Raw_option.to_string kwd in
    if curr <> keyword then
      get_param kwd rest
    else
      match rest with
      | [] -> raise (No_param_for_option keyword)
      | value :: _ -> Raw_option.process kwd value

(* return (argc, argv) *)
let init () =
  (Array.length Sys.argv, Array.to_list Sys.argv)

exception More_than_once of string
exception Option_is_mandatory of string
exception Duplicates_in_specification of string

let string_of_strings l =
  String.concat ", " l

(* find if the short or the long option was used on the CLI *)
let match_kwd (kwd: string list) (args: string list): string =
  if L.length kwd > L.length (List.sort_uniq String.compare kwd) then
    raise (Duplicates_in_specification (string_of_strings kwd));
  let matched = L.filter (fun arg -> L.exists ((=) arg) kwd) args in
  match matched with
  | [] -> raise (Option_is_mandatory (string_of_strings kwd))
  | [k] -> k
  | _ -> raise (More_than_once (string_of_strings kwd))

(* for mandatory options *)

let get_int (kwd: string list) (args: string list): int =
  let k = match_kwd kwd args in
  match get_param (Int k) args with
  | I i -> i
  | other -> raise (Not_an_int (k ^ " " ^ (Processed_option.to_string other)))

let get_string (kwd: string list) (args: string list): string =
  let k = match_kwd kwd args in
  match get_param (String k) args with
  | S s -> s
  | other -> raise (Not_a_string (k ^ " " ^ (Processed_option.to_string other)))

let get_float (kwd: string list) (args: string list): float =
  let k = match_kwd kwd args in
  match get_param (Float k) args with
  | F f -> f
  | other -> raise (Not_a_float (k ^ " " ^ (Processed_option.to_string other)))

let get_bool (kwd: string list) (args: string list): bool =
  let k = match_kwd kwd args in
  match get_param (Bool k) args with
  | B b -> b
  | other -> raise (Not_a_bool (k ^ " " ^ (Processed_option.to_string other)))

let get_set_bool (kwd: string list) (args: string list): bool =
  try let _ = match_kwd kwd args in true
  with Option_is_mandatory _ -> false

let get_reset_bool (kwd: string list) (args: string list): bool =
  not (get_set_bool kwd args)

(* for optional options *)

let get_int_opt (kwd: string list) (args: string list): int option =
  try Some (get_int kwd args)
  with Option_is_mandatory _ -> None

let get_string_opt (kwd: string list) (args: string list): string option =
  try Some (get_string kwd args)
  with Option_is_mandatory _ -> None

let get_float_opt (kwd: string list) (args: string list): float option =
  try Some (get_float kwd args)
  with Option_is_mandatory _ -> None

let get_bool_opt (kwd: string list) (args: string list): bool option =
  try Some (get_bool kwd args)
  with Option_is_mandatory _ -> None
