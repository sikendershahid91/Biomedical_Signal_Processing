function [ out_SSI ] = SimpleSquareIntegral(input_waveform)
  N = length(input_waveform);
  out_SSI = sum(abs(input_waveform).^2);
end
