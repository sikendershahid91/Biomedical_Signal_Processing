function [ out_MMAV2 ] = ModifiedMeanAbsValue2(input_waveform)
  N = length(input_waveform);
  out_MMAV2 = 0;
  for n = 1:1:N
    if n > 0.75*N
      weight = 4*(n-N)/N;
    elseif n < 0.25*N
      weight = 4*n/N;
    else
      weight = 1;
    end
    out_MMAV2 = out_MMAV2 + weight*abs(input_waveform(n));
  end
  out_MMAV2 = (1/N)*out_MMAV2;
end
