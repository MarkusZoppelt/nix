{
  homebrew = {
    brews = [
      "bazelisk"
      "cmake"
      "lcov"
      "llvm@16"
      "openjdk@17"
    ];
    casks = [
      "1password"
      "1password-cli"
      "slack"
      "visual-studio-code"
    ];
  };

  # Set environment variables for llvm@16
  environment.variables = {
    PATH = "/opt/homebrew/opt/llvm@16/bin:$PATH";
    LDFLAGS="-L/opt/homebrew/opt/llvm@16/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm@16/lib/c++";
    CPPFLAGS="-I/opt/homebrew/opt/llvm@16/include";
  };

  networking.hostName = "G-Man";
}
