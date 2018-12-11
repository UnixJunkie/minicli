# Minicli

Minimalist OCaml library for command line parsing.
Look into the test.ml file for usage examples/quickstart.

# Example session with the test program

    # _build/default/test.exe
    usage:
    _build/default/test.exe {-i|--input} <file> {-o|--output} <file> -n <int> -x <float> [-v] [--hi <string>]

    # _build/default/test.exe -i
    Fatal error: exception Minicli__CLI.No_param_for_option("-i")

    # _build/default/test.exe -i input.txt
    Fatal error: exception Minicli__CLI.Option_is_mandatory("-o")

    # _build/default/test.exe -i input.txt -o output.txt
    Fatal error: exception Minicli__CLI.Option_is_mandatory("-n")

    # _build/default/test.exe -i input.txt -o output.txt -n /dev/null
    Fatal error: exception Minicli__CLI.Not_an_int("/dev/null")

    # _build/default/test.exe -i input.txt -o output.txt -n 123
    Fatal error: exception Minicli__CLI.Option_is_mandatory("-x")

    # _build/default/test.exe -i input.txt -o output.txt -n 123 -x /dev/null
    Fatal error: exception Minicli__CLI.Not_a_float("/dev/null")

    # _build/default/test.exe -i input.txt -o output.txt -n 123 -x 0.123
    i: input.txt o: output.txt n: 123 x: 0.123000 v: false

    # _build/default/test.exe -i input.txt -o output.txt -n 123 -x 0.123 -v
    i: input.txt o: output.txt n: 123 x: 0.123000 v: true

    # _build/default/test.exe -i input.txt -o output.txt -n 123 -x 0.123 -v -i input.bin
    Fatal error: exception Minicli__CLI.More_than_once("-i, --input")

    # _build/default/test.exe --toto titi -i input.txt -o output.txt -n 123 -x 0.123 -v -y 42
    Fatal error: exception Minicli__CLI.Unused_options("--toto,-y")
