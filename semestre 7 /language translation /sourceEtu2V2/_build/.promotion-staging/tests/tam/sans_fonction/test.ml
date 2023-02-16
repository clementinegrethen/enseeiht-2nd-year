open Rat
open Compilateur

(* Changer le chemin d'accès du jar. *)
let runtamcmde = "java -jar ../../../../../tests/runtam.jar"
(* let runtamcmde = "java -jar /mnt/n7fs/.../tools/runtam/runtam.jar" *)

(* Execute the TAM code obtained from the rat file and return the ouptut of this code *)
let runtamcode cmde ratfile =
  let tamcode = compiler ratfile in
  print_string tamcode;
  let (tamfile, chan) = Filename.open_temp_file "test" ".tam" in
  output_string chan tamcode;
  close_out chan;
  let ic = Unix.open_process_in (cmde ^ " " ^ tamfile) in
  let printed = input_line ic in
  close_in ic;
  (*Sys.remove tamfile;*)    (* à commenter si on veut étudier le code TAM. *)
  String.trim printed
  

(* Compile and run ratfile, then print its output *)
let runtam ratfile =
  print_string (runtamcode runtamcmde ratfile)
  

(****************************************)
(** Chemin d'accès aux fichiers de test *)
(****************************************)

let pathFichiersRat = "../../../../../tests/tam/sans_fonction/fichiersRat/"

(**********)
(*  TESTS *)
(**********)

(* requires ppx_expect in jbuild, and `opam install ppx_expect` *)

let%expect_test "testprintint" =
  runtam (pathFichiersRat^"testprintint.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 40, characters 2-45
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testprintint.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  LOADL 42SUBR IOUT


  POP (0) 0

  HALT |}]

let%expect_test "testprintbool" =
  runtam (pathFichiersRat^"testprintbool.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 44, characters 2-46
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testprintbool.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  LOADL 1SUBR BOUT


  POP (0) 0

  HALT |}]

let%expect_test "testprintrat" =
   runtam (pathFichiersRat^"testprintrat.rat");
   [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 48, characters 3-46
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testprintrat.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  LOADL 4
  LOADL 5
  CALL (ST) normCALL (ST) ROUT

  POP (0) 0

  HALT |}]
   

let%expect_test "testaddint" =
  runtam (pathFichiersRat^"testaddint.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 53, characters 2-43
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testaddint.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  LOADL 20
  LOADL 22
  SUBR IAddSUBR IOUT


  POP (0) 0

  HALT |}]

let%expect_test "testaddrat" =
  runtam (pathFichiersRat^"testaddrat.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 57, characters 2-43
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testaddrat.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  LOADL 1
  LOADL 2
  CALL (ST) norm
  LOADL 2
  LOADL 3
  CALL (ST) norm
  CALL (ST) raddCALL (ST) ROUT

  POP (0) 0

  HALT |}]

let%expect_test "testmultint" =
  runtam (pathFichiersRat^"testmultint.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 61, characters 2-44
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testmultint.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  LOADL 20
  LOADL 22
  SUBR IMulSUBR IOUT


  POP (0) 0

  HALT |}]

let%expect_test "testmultrat" =
  runtam (pathFichiersRat^"testmultrat.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 65, characters 2-44
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testmultrat.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  LOADL 7
  LOADL 2
  CALL (ST) norm
  LOADL 4
  LOADL 3
  CALL (ST) norm
  CALL (ST) rmulCALL (ST) ROUT

  POP (0) 0

  HALT |}]

let%expect_test "testnum" =
  runtam (pathFichiersRat^"testnum.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 69, characters 2-40
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testnum.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  PUSH 2
  LOADL 4
  LOADL 7
  CALL (ST) normSTORE (2) 0[SB]

  STORE (2) 0[SB]
  SUBR IOUT


  POP (0) 2

  HALT |}]

let%expect_test "testdenom" =
  runtam (pathFichiersRat^"testdenom.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 73, characters 2-42
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testdenom.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  PUSH 2
  LOADL 4
  LOADL 7
  CALL (ST) normSTORE (2) 0[SB]

  STORE (2) 0[SB]
  SUBR IOUT


  POP (0) 2

  HALT |}]

let%expect_test "testwhile1" =
  runtam (pathFichiersRat^"testwhile1.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 77, characters 2-43
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testwhile1.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  PUSH 1
  LOADL 1STORE (1) 0[SB]

  PUSH 1
  LOADL 1STORE (1) 1[SB]

  label1
  STORE (1) 1[SB]

  LOADL 10
  SUBR ILssJUMPIF (0) label2
  STORE (1) 0[SB]

  LOADL 2
  SUBR IAddSTORE (1) 0[SB]

  STORE (1) 1[SB]

  LOADL 1
  SUBR IAddSTORE (1) 1[SB]

  POP (0) 0
  JUMP label1
  label2

  STORE (1) 0[SB]
  SUBR IOUT


  POP (0) 2

  HALT |}]

let%expect_test "testif1" =
  runtam (pathFichiersRat^"testif1.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 81, characters 2-40
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testif1.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  PUSH 1
  LOADL 1STORE (1) 0[SB]

  PUSH 1
  LOADL 1STORE (1) 1[SB]

  STORE (1) 0[SB]

  STORE (1) 1[SB]

  SUBR IEqJUMPIF (0) label3
  LOADL 18SUBR IOUT


  POP (0) 0
  JUMP label4
  label3
  LOADL 21SUBR IOUT


  POP (0) 0
  label4

  POP (0) 2

  HALT |}]

let%expect_test "testif2" =
  runtam (pathFichiersRat^"testif2.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  End_of_file
  Raised at Stdlib.input_line.scan in file "stdlib.ml", line 450, characters 14-31
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 16, characters 16-29
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 85, characters 2-40
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19

  Trailing output
  ---------------
  Error: A JNI error has occurred, please check your installation and try again
  Exception in thread "main" java.lang.UnsupportedClassVersionError: runtam/Run has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
  	at java.lang.ClassLoader.defineClass1(Native Method)
  	at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
  	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
  	at java.net.URLClassLoader.defineClass(URLClassLoader.java:473)
  	at java.net.URLClassLoader.access$100(URLClassLoader.java:74)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:369)
  	at java.net.URLClassLoader$1.run(URLClassLoader.java:363)
  	at java.security.AccessController.doPrivileged(Native Method)
  	at java.net.URLClassLoader.findClass(URLClassLoader.java:362)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  	at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:355)
  	at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  	at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:601)
  ; ../../../../../tests/tam/sans_fonction/fichiersRat/testif2.rat
  JUMP main

  pgcd
  LOADL 0
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  boucle
  LOAD (1) 5[LB]
  JUMPIF (0) fin
  LOAD (1) 4[LB]
  LOAD (1) 5 [LB]
  SUBR IMod
  STORE (1) 3[LB]
  LOAD (1) 5[LB]
  STORE (1) 4[LB]
  LOAD (1) 3[LB]
  STORE(1) 5[LB]
  JUMP boucle
  fin
  LOAD (1) 4[LB]
  RETURN (1) 2

  norm
  LOAD (1) -2[LB]
  LOAD (1) -1[LB]
  CALL (LB) pgcd
  LOAD (1) -2[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  LOAD (1) -1[LB]
  LOAD (1) 3[LB]
  SUBR IDiv
  RETURN (2) 2

  ROut
  LOADL '['
  SUBR COut
  LOAD (1) -2[LB]
  SUBR IOut
  LOADL '/'
  SUBR COut
  LOAD (1) -1[LB]
  SUBR IOut
  LOADL ']'
  SUBR COut
  RETURN (0) 2

  RAdd
  LOAD (1) -4[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  LOAD (1) -2[LB]
  LOAD (1) -3[LB]
  SUBR IMul
  SUBR IAdd
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4

  RMul
  LOAD (1) -4[LB]
  LOAD (1) -2[LB]
  SUBR IMul
  LOAD (1) -3[LB]
  LOAD (1) -1[LB]
  SUBR IMul
  CALL (ST) norm
  RETURN (2) 4




  main
  PUSH 1
  LOADL 1STORE (1) 0[SB]

  PUSH 1
  LOADL 2STORE (1) 1[SB]

  STORE (1) 0[SB]

  STORE (1) 1[SB]

  SUBR IEqJUMPIF (0) label5
  LOADL 18SUBR IOUT


  POP (0) 0
  JUMP label6
  label5
  LOADL 21SUBR IOUT


  POP (0) 0
  label6

  POP (0) 2

  HALT |}]

let%expect_test "factiter" =
  runtam (pathFichiersRat^"factiter.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  (Failure "Probleme analyse code affectable")
  Raised at Stdlib.failwith in file "stdlib.ml", line 29, characters 17-33
  Called from Rat__PasseCodeRatToTam.analyse_code_expression in file "passeCodeRatToTam.ml", line 49, characters 8-36
  Called from Rat__PasseCodeRatToTam.analyse_code_expression in file "passeCodeRatToTam.ml", line 49, characters 43-71
  Called from Rat__PasseCodeRatToTam.analyse_code_instruction in file "passeCodeRatToTam.ml", line 130, characters 13-38
  Called from Stdlib__list.map in file "list.ml", line 92, characters 20-23
  Called from Stdlib__list.map in file "list.ml", line 92, characters 32-39
  Called from Stdlib__list.map in file "list.ml", line 92, characters 32-39
  Called from Stdlib__list.map in file "list.ml", line 92, characters 32-39
  Called from Rat__PasseCodeRatToTam.analyse_code_bloc in file "passeCodeRatToTam.ml", line 160, characters 10-45
  Called from Rat__PasseCodeRatToTam.analyser in file "passeCodeRatToTam.ml", line 191, characters 1-23
  Called from Rat__Compilateur.compiler in file "compilateur.ml", line 94, characters 28-57
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 10, characters 16-32
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 89, characters 2-41
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19 |}]

let%expect_test "complique" =
  runtam (pathFichiersRat^"complique.rat");
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)

  (Failure "Probleme analyse code affectable")
  Raised at Stdlib.failwith in file "stdlib.ml", line 29, characters 17-33
  Called from Rat__PasseCodeRatToTam.analyse_code_expression in file "passeCodeRatToTam.ml", line 49, characters 43-71
  Called from Rat__PasseCodeRatToTam.analyse_code_instruction in file "passeCodeRatToTam.ml", line 98, characters 12-37
  Called from Stdlib__list.map in file "list.ml", line 92, characters 20-23
  Called from Stdlib__list.map in file "list.ml", line 92, characters 32-39
  Called from Rat__PasseCodeRatToTam.analyse_code_bloc in file "passeCodeRatToTam.ml", line 160, characters 10-45
  Called from Rat__PasseCodeRatToTam.analyser in file "passeCodeRatToTam.ml", line 191, characters 1-23
  Called from Rat__Compilateur.compiler in file "compilateur.ml", line 94, characters 28-57
  Called from Sans_fonction_tam__Test.runtamcode in file "tests/tam/sans_fonction/test.ml", line 10, characters 16-32
  Called from Sans_fonction_tam__Test.runtam in file "tests/tam/sans_fonction/test.ml" (inlined), line 24, characters 15-46
  Called from Sans_fonction_tam__Test.(fun) in file "tests/tam/sans_fonction/test.ml", line 93, characters 2-42
  Called from Expect_test_collector.Make.Instance_io.exec in file "collector/expect_test_collector.ml", line 262, characters 12-19 |}]

