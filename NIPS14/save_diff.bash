for file in *.tex
do
  git diff --word-diff --color e8ba65c09ea874dbc73ddae2eeabbbc80840039f 258046c7d84a5247498a2bb33d816f89ed5485db  $file > 'diff_$file'
done
