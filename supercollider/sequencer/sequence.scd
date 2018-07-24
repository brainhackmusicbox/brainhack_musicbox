(
(
part1:
(
notes: ['C-3', 'G-4', 'Bb-3', 'F#-3'],
durs: {|self| {[0.5, 1].wchoose([0.55, 0.45])} ! (self.notes.size)},
legato: {|self| 0.5 ! (self.notes.size)}
),
alt1:
(
notes: ['Eb-3', 'C-3', 'A-3', 'Bb-3', 'F#-3'],
durs: {|self| {[0.5, 1].wchoose([0.6, 0.4])} ! (self.notes.size)},
legato: {|self| 0.5 ! (self.notes.size)}
),
alt2:
(
notes: ['D-3', 'Eb-3', 'G-3', 'F#-3', 'G-4', 'C-3'],
durs: {|self| {[0.5, 1].wchoose([0.4, 0.6])} ! (self.notes.size)},
legato: {|self| 0.5 ! (self.notes.size)}
),
alt3:
(
notes: ['Eb-3', 'C-3', 'F#-3', 'A-4', 'C-3'],
durs: {|self| {[0.5, 1].wchoose([0.38, 0.62])} ! (self.notes.size)},
legato: {|self| 0.5 ! (self.notes.size)}
),

part2:
(
notes: ['F#-3', 'F#-3', 'C-3', 'A-2', 'Eb-3', 'G-3'],
durs: {|self| {[0.5, 1].wchoose([0.45, 0.55])} ! (self.notes.size)},
legato: {|self| 0.5 ! (self.notes.size)}
),
part2_1:
(
notes: ['E-3', 'F-3', 'F#-3', 'G-3', 'Ab-3', 'A-3'],
durs: [0.25, 0.25, 0.5, 0.25, 0.25, 0.5],
legato: {|self| 0.5 ! (self.notes.size)}
)
)
)