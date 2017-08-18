
open Printf

let main () =
  let argc, args = CLI.init () in
  if argc = 1 then
    (printf "usage:\n\
             %s -i|--input <file> -o|--output <file> -n <int> -x <float> \
             [-v] [--hi <string>]\n" Sys.argv.(0);
     exit 1);
  let input_fn = CLI.get_string ["-i";"--input"] args in
  let output_fn = CLI.get_string ["-o"] args in
  let n = CLI.get_int ["-n"] args in
  let x = CLI.get_float ["-x"] args in
  let verbose = CLI.get_set_bool ["-v"] args in
  let maybe_say_hi = CLI.get_string_opt ["--hi"] args in
  printf "i: %s o: %s n: %d x: %f v: %s\n"
    input_fn output_fn n x (string_of_bool verbose);
  match maybe_say_hi with
  | None -> ()
  | Some name -> printf "Hi %s!\n" name

let () = main ()
