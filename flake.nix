{
  outputs = { self, nixpkgs }: {

    configurablePackages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };

      {
        options = {
          target = {
            type = lib.types.str;
            default = "World";
            description = "Who to greet.";
          };

          big = {
            type = lib.types.bool;
            default = false;
            description = "Whether to print a big greeting.";
          };

          printer = {
            type = lib.types.nullOr (lib.types.package);
            default = null;
            description = "Package used to print the greeting.";
          };
        };

        applyOptions = { target, big, printer }:
          runCommand "hello" {}
            ''
              mkdir -p $out/bin
              echo "#! $shell" > $out/bin/hello
              ${if printer != null then ''
                echo "${printer}/bin/${printer.meta.mainProgram} Hello ${target}!" >> $out/bin/hello
              '' else if big then ''
                echo "${toilet}/bin/toilet -f smmono9 --gay Hello ${target}!" >> $out/bin/hello
              '' else ''
                echo "echo Hello ${target}!" >> $out/bin/hello
              ''}
              chmod +x $out/bin/hello
            '';
      };
  };
}
