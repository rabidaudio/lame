class WaveFileGenerator
  attr_accessor :mode, :bits, :sample_rate, :length, :hertz

  def initialize(options = {})
    @mode        = options[:mode]   || :stereo
    @bits        = options[:bits]   || 16
    @sample_rate = options[:sample_rate] || 44100
    @length      = options[:length] || 1
    @hertz       = options[:hertz]  || 440
  end

  def generate
    wav_file = Tempfile.new('sine.wav')

    format = WaveFile::Format.new(mode, pcm_type, sample_rate)
    WaveFile::Writer.new(wav_file.path, format) do |writer|
      samples = (0...sample_rate*length).map do |offset|
        sample = (Math.sin((Math::PI*2 / scale) * offset) * max).round
        [sample, sample]
      end

      buffer = WaveFile::Buffer.new(samples, format)
      writer.write(buffer)
    end

    wav_file
  end

  def max
    2**(bits-1) - 1
  end

  def scale
    sample_rate / hertz
  end

  def pcm_type
    case bits
    when 16
      :pcm_16
    when 24
      :pcm_24
    end
  end

end
