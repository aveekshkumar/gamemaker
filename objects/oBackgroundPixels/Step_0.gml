// oBackgroundPixels Create Event
pixels = [];

// Create random pixels across screen
for (var i = 0; i < 200; i++) {
    var pix = {
        x: irandom_range(0, room_width),
        y: irandom_range(0, room_height),
        alpha: random_range(0.1, 0.4),
        speed: random_range(0.5, 2),
        size: irandom_range(1, 3)
    };
    array_push(pixels, pix);
}