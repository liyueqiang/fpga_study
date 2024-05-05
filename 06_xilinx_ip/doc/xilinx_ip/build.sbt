name := "xilinx_ip"
ThisBuild / version := "1.0"
ThisBuild / scalaVersion := "2.12.15"

val spinalVersion = "1.6.0"
val spinalCore = "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion
val spinalLib = "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion
val spinalIdslPlugin = compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)

lazy val mylib = (project in file("."))
  .settings(
    name := "xilinx_ip",
    libraryDependencies ++= Seq(spinalCore, spinalLib, spinalIdslPlugin)
  )

fork := true