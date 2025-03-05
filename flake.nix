{
  outputs = { self, nixpkgs }: {

    configurablePackages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };

      {
        options = {
          who = {
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
            description = "Package used to print the greeting. Example: `nixpkgs#ponysay`";
          };
        };

        applyOptions = { who, big, printer }:
          runCommand "hello" {}
            ''
              mkdir -p $out/bin
              echo "#! $shell" > $out/bin/hello
              ${if printer != null then ''
                echo "${printer}/bin/${printer.meta.mainProgram or (lib.getName printer)} -- Hello ${who}!" >> $out/bin/hello
              '' else if big then ''
                echo "${toilet}/bin/toilet -f smmono9 --gay -- Hello ${who}!" >> $out/bin/hello
              '' else ''
                echo "echo Hello ${who}!" >> $out/bin/hello
              ''}
              chmod +x $out/bin/hello
            '';
      };
  };
}
