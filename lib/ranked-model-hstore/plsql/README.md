## Spreading method.

Ruby handles numbers in range of -2147483648..2147483647. It's more than 4 billion values. I suppose that every collection of goods includes no more than 50000 units. Thus, it's possible to allocate 50000 entries among 4 billion with a step of ~85000.

Example. Given: 40000 units are in DB. How does the spreading should look like?

    $ -2b-----------------------0------------------------+2b
    $    1t.......10t...........25t.............40t

So we have free space for 10000 units.

If amount of units exceed 50000, spreading can be squeezed. Like this:

$ -2b-----------------------0------------------------+2b
$    1t....10t......25t......40t......55t....65t
