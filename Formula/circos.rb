class Circos < Formula
  # cite "https://doi.org/10.1101/gr.092759.109"
  desc "Visualize data in a circular layout"
  homepage "http://circos.ca"
  url "http://circos.ca/distribution/circos-0.69-6.tgz"
  sha256 "52d29bfd294992199f738a8d546a49754b0125319a1685a28daca71348291566"

  depends_on "cpanminus" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "perl" unless OS.mac?

  def install
    rm "bin/circos.exe"
    libexec.install Dir["*"]

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    unless OS.mac?
      system "cpanm", "--self-contained", "-l", libexec,
        "Clone", "List::MoreUtils", "Math::Round", "Params::Validate", "Regexp::Common"
    end
    system "cpanm", "--self-contained", "-l", libexec,
      "Config::General", "Font::TTF::Font", "GD", "Math::Bezier",
      "Math::VecStat", "Number::Format", "Readonly", "SVG", "Set::IntSpan",
      "Statistics::Basic", "Text::Format"

    (bin/"circos").write_env_script("#{libexec}/bin/circos", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"circos", "-conf", libexec/"example/etc/circos.conf", "-debug_group", "summary,timer"
    assert_predicate testpath/"circos.png", :exist?
    assert_predicate testpath/"circos.svg", :exist?
  end
end
