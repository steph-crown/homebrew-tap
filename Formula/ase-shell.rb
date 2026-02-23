class AseShell < Formula
  desc "àṣẹ – a small Unix-style interactive shell in Rust"
  homepage "https://github.com/steph-crown/ase"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.3/ase-shell-aarch64-apple-darwin.tar.xz"
      sha256 "a03815dd968b5ffb99074d7f24d92ebeaabf844103c64e5fe3b45d2cac9da7fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.3/ase-shell-x86_64-apple-darwin.tar.xz"
      sha256 "5f52ac3de7e293a132d912529a2fa20a9a47405123b40277f3863d9b3a7847d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.3/ase-shell-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62889f15b39d897328a5ed3525b1cac0524a644e3b91033d3198e6ae9aa20fb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.3/ase-shell-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee44ab65ee504f2fa7d81f575315e94e9bc331bb30d86ee09e2d344792484bca"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ase" if OS.mac? && Hardware::CPU.arm?
    bin.install "ase" if OS.mac? && Hardware::CPU.intel?
    bin.install "ase" if OS.linux? && Hardware::CPU.arm?
    bin.install "ase" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
