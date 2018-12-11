# Minicli

Minimalist OCaml library for command line parsing.
Look into the test.ml file for usage examples/quickstart.

# Example session with the test program

    # ./test
    usage:
    ./test {-i|--input} <file> {-o|--output} <file> -n <int> -x <float> [-v] [--hi <string>]

    # ./test -i
    Fatal error: exception Minicli__CLI.No_param_for_option("-i")

    # ./test -i input.txt
    Fatal error: exception Minicli__CLI.Option_is_mandatory("-o")

    # ./test -i input.txt -o output.txt
    Fatal error: exception Minicli__CLI.Option_is_mandatory("-n")

    # ./test -i input.txt -o output.txt -n /dev/null
    Fatal error: exception Minicli__CLI.Not_an_int("/dev/null")

    # ./test -i input.txt -o output.txt -n 123
    Fatal error: exception Minicli__CLI.Option_is_mandatory("-x")

    # ./test -i input.txt -o output.txt -n 123 -x /dev/null
    Fatal error: exception Minicli__CLI.Not_a_float("/dev/null")

    # ./test -i input.txt -o output.txt -n 123 -x 0.123
    i: input.txt o: output.txt n: 123 x: 0.123000 v: false

    # ./test -i input.txt -o output.txt -n 123 -x 0.123 -v
    i: input.txt o: output.txt n: 123 x: 0.123000 v: true

    # ./test -i input.txt -o output.txt -n 123 -x 0.123 -v -i input.bin
    Fatal error: exception Minicli__CLI.More_than_once("-i, --input")

    # ./test --toto titi -i input.txt -o output.txt -n 123 -x 0.123 -v -y 42
    Fatal error: exception Minicli__CLI.Unused_options("--toto,-y")
