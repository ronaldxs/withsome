#!/usr/bin/env bash

choices=( 'one' 'two' 'three' 'four' 'five' ) # sample choices
select dummy in "${choices[@]}"; do  # present numbered choices to user
  # Parse ,-separated numbers entered into an array.
  # Variable $REPLY contains whatever the user entered.
  IFS=', ' read -ra selChoices <<<"$REPLY"
  # Loop over all numbers entered.
  for choice in "${selChoices[@]}"; do
    # Validate the number entered.
#    (( choice >= 1 && choice <= ${#choices[@]} )) || { echo "Invalid choice: $choice. Try again." >&2; continue 2; }
    if [ -n "${choice//[0-9]}" ] || ! (( choice >= 1 && choice <= ${#choices[@]} ))
    then
        echo "Invalid choice: $choice. Try again." >&2;
        continue 2;
    fi
    # If valid, echo the choice and its number.
    echo "Choice #$(( ++i )): ${choices[choice-1]} ($choice)"
  done
  # All choices are valid, exit the prompt.
  break
done

echo "Done."
