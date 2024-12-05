# Advent of code 2024

```


               ┏━━━━━━━━━━━━━━┓
               ┃              ┃           
               ┃              ┃         
               ┃              ┃      ┏  HAPPPY  
               ┃              ┃      ┖┓ HOLiDAYS! 
               ┃           o  ┃       ┖━
               ┃              ┃           
               ┃              ┃           
               ┃              ┃                  
_______________┃______________┃_________________________________________________
```

## Day Details

* [Day 1](https://adventofcode.com/2024/day/1) - Straight forward day. I had a passing thought that maybe it could be done w/o finding the distances, but that would not work, not shortcuts. 
* [Day 2](dhttps://adventofcode.com/2024/day/2) - Straight forward day.
* [Day 3](https://adventofcode.com/2024/day/3) - Straight forward day.
* [Day 4](https://adventofcode.com/2024/day/4) - For part two, I didn't iterate, I just removed all the text between don't() and do() and then ran the same code as part 1. You can't just remove it however, as it might leave a problem muldon't()blahdo()(4,4) - would result in a valid mul after the removeal, so you have to add some text in to replace it, a space works.
* [Day 5](https://adventofcode.com/2024/day/5) - Fun day!
  - Part I: Pretty straight forward, there is a tricky part for me, I only tested forward rules first. I'm not sure if the last entry is an edge case, or not, but I swapped the logic out to test fwd and bkwd, because it can't hurt to fail faster.
  - Part II: Looked crazy. I think when I thought about it, it might take a very long time to order them. My first thought was that the middle one, might not be the same in all ways to make the thing valid, like there could be more than one valid list, and I think that is true, but only if you make changes that are not in the rules? I'm really not sure. I think I can make valid entries that don't have the middle correct for unspecified entries, but as long as their rules are perfect, it would work out. So When I looked at part II, I was like, no way.. but just going about it logically it worked. 
  - So said another way.. If you just say, ordered is valid, so you set your rules up that higher numbers must be after lower, and you start with `14,10,12` you end up with 10,12,14 as the only possible valid ordering.
  - But if you say, 12 must come before 14, is the only rule, then `10,12,14` is valid, but so is `12,14,10` and so I was worried that it would be difficult if they don't specify it all, but have some expectation about how you change the list. like, only doing swaps from the original till it's valid, or something.
* [Day 6](https://adventofcode.com/2024/day/6) - Can't wait!
