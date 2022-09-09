class Responsive<T> {
  final T mobile;
  final T? xs;
  final T? sm;
  final T? md;
  final T? lg;
  final T? xl;
  final T? xxl;

  Responsive(this.mobile, {this.xs, this.sm, this.md, this.lg, this.xl, this.xxl});

  Map<String, dynamic> toMap() {
    return {
      "mobile": mobile,
      "xs": xs,
      "sm": sm,
      "md": md,
      "lg": lg,
      "xl": xl,
      "xxl": xxl,
    };
  }
}
