import { describe, it, expect } from "vitest";
import { APP_NAME } from "./index";

describe("shared-ts", () => {
  it("exports APP_NAME", () => {
    expect(APP_NAME).toBe("My App");
  });
});
