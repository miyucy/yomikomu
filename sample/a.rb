require 'benchmark/ips'

Benchmark.ips do |x|
  x.report('without yomikomu') do
    %x(YOMIKOMU_STORAGE=fs2 YOMIKOMU_AUTO_COMPILE=false RUBYOPT=-ryomikomu ruby -v b.rb)
  end

  x.report('without zlib') do
    %x(YOMIKOMU_STORAGE=fs2 YOMIKOMU_AUTO_COMPILE=true RUBYOPT=-ryomikomu ruby -v b.rb)
  end

  x.report('with zlib') do
    %x(YOMIKOMU_STORAGE=fs2 YOMIKOMU_AUTO_COMPILE=true YOMIKOMU_GZ=true RUBYOPT=-ryomikomu ruby -v b.rb)
  end

  x.report('with zlib level=9') do
    %x(YOMIKOMU_STORAGE=fs2 YOMIKOMU_AUTO_COMPILE=true YOMIKOMU_GZ=true YOMIKOMU_GZ_LEVEL=9 RUBYOPT=-ryomikomu ruby -v b.rb)
  end

  x.compare!
end

__END__
Comparison:
           with zlib:        0.6 i/s
        without zlib:        0.6 i/s - 1.03x slower
Comparison:
   with zlib level=9:        0.6 i/s
        without zlib:        0.6 i/s - 1.03x slower

1st
Comparison:
    without yomikomu:        0.8 i/s
           with zlib:        0.6 i/s - 1.21x slower
Comparison:
    without yomikomu:        0.8 i/s
           with zlib:        0.6 i/s - 1.23x slower

1st
Comparison:
    without yomikomu:        0.8 i/s
   with zlib level=9:        0.6 i/s - 1.21x slower
2nd
Comparison:
    without yomikomu:        0.8 i/s
   with zlib level=9:        0.7 i/s - 1.26x slower
