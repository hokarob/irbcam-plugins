function limitAngle(angle) {
    let limitedAngle = (angle + 180) % 360;
    if (limitedAngle < 0) {
        limitedAngle += 360;
    }
    return (limitedAngle - 180);
}
