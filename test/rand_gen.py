import random
import argparse
import sys

def generate_random_numbers(count=20, min_val=1, max_val=10, output_file=None, seed=None):
    """
    Generate random numbers and write them to a file or stdout.
    
    Args:
        count: Number of random numbers to generate
        min_val: Minimum value (inclusive)
        max_val: Maximum value (inclusive)
        output_file: Path to the output file or None for stdout
        seed: Random seed for reproducibility
    """
    # Set random seed if provided for reproducibility
    if seed is not None:
        random.seed(seed)
        
    numbers = [random.randint(min_val, max_val) for _ in range(count)]
    
    if output_file:
        with open(output_file, 'w') as f:
            for number in numbers:
                f.write(f"{number}\n")
        print(f"Successfully generated {count} random numbers between {min_val}-{max_val} in {output_file}")
    else:
        # Output to stdout
        for number in numbers:
            print(number)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate random numbers')
    parser.add_argument('-c', '--count', type=int, default=20, 
                        help='Number of random numbers to generate (default: 20)')
    parser.add_argument('--min', type=int, default=1, 
                        help='Minimum value (default: 1)')
    parser.add_argument('--max', type=int, default=10, 
                        help='Maximum value (default: 10)')
    parser.add_argument('-o', '--output', type=str, default=None,
                        help='Output file (default: output to stdout)')
    parser.add_argument('-s', '--seed', type=int, default=None,
                        help='Random seed for reproducibility')
    
    args = parser.parse_args()
    
    # Convert empty string to None for output_file
    output_file = args.output if args.output else None
    
    generate_random_numbers(
        count=args.count, 
        min_val=args.min, 
        max_val=args.max, 
        output_file=output_file,
        seed=args.seed
    )
