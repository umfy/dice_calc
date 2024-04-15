# Dice probability alculator
## About
Let's define success as rolling 6 or more on a die. The script can calculate a probablility of getting any possible number of successes when rolling any number of dice at once. 

The scores assigned to meaning of success can be modified in `dice.gleam` file.

The size and number of dice can be modified in `dice_calc.gleam`.



## Output
Rolling d8 and d10 gives an output in a table:
```
score | percentage | total
  3        3.75        3.75
  2       20.00       23.75
  1       36.25       60.00
  0       28.75       88.75
 -1       10.00       98.75
 -2        1.25      100.00
 ```

## Usage

```sh
gleam run   # Run the project on Erlang
gleam run --target=javascript # Run on JS
```
