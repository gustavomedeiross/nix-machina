{ pkgs }:

# for playing MIDIs in Frescobaldi
# On Frescobaldi, configure
# Preferences -> MIDI -> Player output: FluidSynth

with pkgs;
[
  fluidsynth
  soundfont-fluid
]
