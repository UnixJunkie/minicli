
module Ht = Hashtbl
module L = List

type args = string list

type option_strings = string list

(* options provided by the user on the CLI are called 'raw';
   they become 'processed' afterwards *)

module Processed_option = struct

  type t = S of string
         | C of char
         | I of int
         | F of float
         | B of bool

  let to_string = function
    | S s -> "S: " ^ s
    | C c -> "C: " ^ (String.make 1 c)
    | I i -> "I: " ^ (string_of_int i)
    | F f -> "F: " ^ (string_of_float f)
    | B b -> "B: " ^ (string_of_bool b)

end

exception Not_an_int of string
exception Not_a_char of string
exception Not_a_string of string
exception Not_a_float of string
exception Not_a_bool of string

module Raw_option = struct

  type t = String of string
         | Char of string
         | Int of string
         | Float of string
         | Bool of string

  let to_string = function
    | String s
    | Char s
    | Int s
    | Float s
    | Bool s -> s

  let read_float s =
    try Scanf.sscanf s "%f" (fun x -> x)
    with _ -> raise (Not_a_float s)

  let read_int s =
    try Scanf.sscanf s "%d" (fun x -> x)
    with _ -> raise (Not_an_int s)

  let read_char s =
    try Scanf.sscanf s "%c" (fun x -> x)
    with _ -> raise (Not_a_char s)

  let read_bool = function
    | "on" | "true" -> true
    | "off" | "false" -> false
    | other -> raise (Not_a_bool other)

  let process x y =
    Processed_option.(
      match x with
      | String _ -> S y
      | Char _ -> C (read_char y)
      | Int _ -> I (read_int y)
      | Float _ -> F (read_float y)
      | Bool _ -> B (read_bool y)
    )

end

module State = struct
  (* store options processed so far *)
  let options_seen = Ht.create 11
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
exception Duplicate_in_specification of string

let string_of_strings l =
  String.concat ", " l

(* find if the short or the long option was used on the CLI *)
let match_kwd (kwd: string list) (args: string list): string =
  if L.length kwd > L.length (List.sort_uniq String.compare kwd) then
    raise (Duplicate_in_specification (string_of_strings kwd));
  let matched = L.filter (fun arg -> L.exists ((=) arg) kwd) args in
  match matched with
  | [] -> raise (Option_is_mandatory (string_of_strings kwd))
  | [k] -> (Hashtbl.add State.options_seen k (); k)
  | _ -> raise (More_than_once (string_of_strings kwd))

exception Unused_options of string

(* find if there are unused options left on the CLI.
   Note that options start with a '-' *)
let finalize () =
  let buff = Buffer.create 80 in
  Array.iteri (fun i arg ->
      (* i = 0: program/command name *)
      if i <> 0 && String.get arg 0 = '-' &&
         not (Hashtbl.mem State.options_seen arg) then
        begin
          if Buffer.length buff > 0 then
            Buffer.add_char buff ','; (* sep *)
          Buffer.add_string buff arg (* unused option *)
        end
    ) Sys.argv;
  if Buffer.length buff > 0 then
    raise (Unused_options (Buffer.contents buff))

(* mandatory options *)

let get_int kwd args =
  let k = match_kwd kwd args in
  match get_param (Raw_option.Int k) args with
  | Processed_option.I i -> i
  | other -> raise (Not_an_int (k ^ " " ^ (Processed_option.to_string other)))

let get_string kwd args =
  let k = match_kwd kwd args in
  match get_param (Raw_option.String k) args with
  | Processed_option.S s -> s
  | other -> raise (Not_a_string (k ^ " " ^ (Processed_option.to_string other)))

let get_char kwd args =
  let k = match_kwd kwd args in
  match get_param (Raw_option.Char k) args with
  | Processed_option.C c -> c
  | other -> raise (Not_a_char (k ^ " " ^ (Processed_option.to_string other)))

let get_float kwd args =
  let k = match_kwd kwd args in
  match get_param (Raw_option.Float k) args with
  | Processed_option.F f -> f
  | other -> raise (Not_a_float (k ^ " " ^ (Processed_option.to_string other)))

let get_bool kwd args =
  let k = match_kwd kwd args in
  match get_param (Raw_option.Bool k) args with
  | Processed_option.B b -> b
  | other -> raise (Not_a_bool (k ^ " " ^ (Processed_option.to_string other)))

let get_set_bool kwd args =
  try let _ = match_kwd kwd args in true
  with Option_is_mandatory _ -> false

let get_reset_bool kwd args =
  not (get_set_bool kwd args)

(* optional options *)

let get_int_opt kwd args =
  try Some (get_int kwd args)
  with Option_is_mandatory _ -> None

let get_string_opt kwd args =
  try Some (get_string kwd args)
  with Option_is_mandatory _ -> None

let get_char_opt kwd args =
  try Some (get_char kwd args)
  with Option_is_mandatory _ -> None

let get_float_opt kwd args =
  try Some (get_float kwd args)
  with Option_is_mandatory _ -> None

let get_bool_opt kwd args =
  try Some (get_bool kwd args)
  with Option_is_mandatory _ -> None

(* optional options with a default value *)

let get_int_def kwd args def =
  match get_int_opt kwd args with
  | None -> def
  | Some i -> i

let get_string_def kwd args def =
  match get_string_opt kwd args with
  | None -> def
  | Some s -> s

let get_char_def kwd args def =
  match get_char_opt kwd args with
  | None -> def
  | Some c -> c

let get_float_def kwd args def =
  match get_float_opt kwd args with
  | None -> def
  | Some f -> f

let get_bool_def kwd args def =
  match get_bool_opt kwd args with
  | None -> def
  | Some b -> b
