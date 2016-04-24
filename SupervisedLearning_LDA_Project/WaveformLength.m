function  [ output_length ] = WaveformLength( input_waveform )
  N = length(input_waveform);
  output_length = 0;
  for i=1:1:N-1
    output_length = output_length + abs(input_waveform(i+1)-input_waveform(i));
  end
end