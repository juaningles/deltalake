 export RAND_SEED=42
 
 python3 rand_gen.py --seed=$RAND_SEED  --min 100 --max 200 --count=100 >> counts.txt
 python3 rand_gen.py --seed=$RAND_SEED  --min 400 --max 800 --count=100 >> counts.txt
 python3 rand_gen.py --seed=$RAND_SEED  --min 1000 --max 1500 --count=400 >> counts.txt
 python3 rand_gen.py --seed=$RAND_SEED  --min 500 --max 900 --count=100 >> counts.txt
 python3 rand_gen.py --seed=$RAND_SEED  --min 2000 --max 2500 --count=400 >> counts.txt
 python3 rand_gen.py --seed=$RAND_SEED  --min 600 --max 1000 --count=100 >> counts.txt
 python3 rand_gen.py --seed=$RAND_SEED  --min 500 --max 1000 --count=100 >> counts.txt
 python3 rand_gen.py --seed=$RAND_SEED  --min 500 --max 1000 --count=100 >> counts.txt
