function lod --wraps='exa $EXA_STANDARD_OPTIONS $EXA_LD_OPTIONS $EXA_LO_OPTIONS' --wraps='eza $EZA_STANDARD_OPTIONS $EZA_LD_OPTIONS $EZA_LO_OPTIONS' --description 'alias lod eza $EZA_STANDARD_OPTIONS $EZA_LD_OPTIONS $EZA_LO_OPTIONS'
  eza $EZA_STANDARD_OPTIONS $EZA_LD_OPTIONS $EZA_LO_OPTIONS $argv
        
end
