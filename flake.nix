{
  outputs = { self, nixpkgs }: {

    configurablePackages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };

      {
        options = {
          target = {
            type = "string";
            default = "World";
            description = "Who to greet.";
          };

          big = {
            type = "boolean";
            default = false;
            description = "Whether to print a big greeting.";
          };
        };

        applyOptions = { target, big }:
          runCommand "hello" {}
            ''
              mkdir -p $out/bin
              echo "#! $shell" > $out/bin/hello
              ${if big then ''
                echo "${toilet}/bin/toilet -f smmono9 --gay Hello ${target}!" >> $out/bin/hello
              '' else ''
                echo "echo Hello ${target}!" >> $out/bin/hello
              ''}
              chmod +x $out/bin/hello
            '';
      };
  };
}
