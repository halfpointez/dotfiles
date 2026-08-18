return {
  black = 0xff15161e,
  white = 0xffc0caf5,
  red = 0xfff7768e,
  green = 0xff9ece6a,
  blue = 0xff7aa2f7,
  yellow = 0xffe0af68,
  orange = 0xffff9e64,
  magenta = 0xffbb9af7,
  cyan = 0xff7dcfff,
  grey = 0xff565f89,
  transparent = 0x00000000,

  bar = {
    bg = 0x1affffff,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0x0affffff,
    border = 0xff565f89
  },
  bg1 = 0xff292e42,
  bg2 = 0xff3b4261,
  bg1_glass = 0x80292e42,
  bg2_glass = 0x803b4261,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}