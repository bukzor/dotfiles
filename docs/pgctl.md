```
                  |
(3) <--- (2)      |      (5)      (8)
 |        /\  --start-->  |        /\
 |        |       |       |        |
\/        |   <--stop--  \/        |
(4)      (1)      |      (6)----->(7)
                  |

```

1. starting, want:down
2. up, want:down
3. stopping
4. down
5. stopping, want:up
6. down, want:up
7. starting
8. up

```
                  |
(2) <-----|       |      (6) ---> (7)
 |        |   --start-->  |\       |
 |        |       |       |        |
\/        |   <--stop--   |       \/
(1)      (4)      |      (5)      (8)
                  |

```

1. down
2. down, want:up
3. starting, want:up
4. up
5. up, want: down
6. stopping want: down
7. starting, want:down
8. starting, want:down

down --start-->
