import { describe, expect, it } from "vitest";
import { GridPoint, GridPoints } from "./grid_point";

describe("GridPoint", () => {
	it("generates gridpoint", () => {
		const gridPoint = new GridPoint(1, 2);

		expect(gridPoint.x).toBe(1);
		expect(gridPoint.y).toBe(2);
	});

	it("returns notation", () => {
		const gridPoint = new GridPoint(1, 2);

		expect(gridPoint.getNotation()).toBe("(1, 2)");
	});
	describe("Coordinates", () => {
		it("return true if two GridPoints have same coordinates", () => {
			const coordinatesA = new GridPoint(1, 2);
			const coordinatesB = new GridPoint(1, 2);

			expect(coordinatesA.hasSomeCoordinates(coordinatesB)).toBe(true);
		});

		it("return false if two GridPoints have different coordinates", () => {
			const coordinatesA = new GridPoint(1, 2);
			const coordinatesB = new GridPoint(3, 4);

			expect(coordinatesA.hasSomeCoordinates(coordinatesB)).toBe(false);
		});
	});

	describe("Neighbor", () => {
		const testCase = [
			[new GridPoint(1, 2), new GridPoint(2, 2), true],
			[new GridPoint(3, 2), new GridPoint(2, 2), true],
			[new GridPoint(2, 1), new GridPoint(2, 2), true],
			[new GridPoint(2, 3), new GridPoint(2, 2), true],
			[new GridPoint(1, 1), new GridPoint(2, 2), false],
			[new GridPoint(3, 1), new GridPoint(2, 2), false],
			[new GridPoint(1, 3), new GridPoint(2, 2), false],
			[new GridPoint(3, 3), new GridPoint(2, 2), false],
		];
		it.each(testCase)("check if %p is neighbor of %p", (a, b, expected) => {
			expect((a as GridPoint).isNeighbor(b as GridPoint)).toBe(expected);
		});
	});
});

describe("GridPoints", () => {
	describe("calclate contains", () => {
		describe("Two Gridpoints", () => {
			it("returns true if Two GridPoints contains GridPoint", () => {
				const coordinatesA = new GridPoint(1, 2);
				const coordinatesB = new GridPoint(3, 4);
				const gridPoints = new GridPoints(coordinatesA, coordinatesB);
				expect(gridPoints.isContained(new GridPoint(1, 2))).toBe(true);
			});

			it("returns false if Two GridPoints not contains GridPoint", () => {
				const coordinatesA = new GridPoint(1, 2);
				const coordinatesB = new GridPoint(3, 4);
				const gridPoints = new GridPoints(coordinatesA, coordinatesB);
				expect(gridPoints.isContained(new GridPoint(4, 5))).toBe(false);
			});
		});

		describe("Three Gridpoints", () => {
			it("returns true if Three GridPoints contains GridPoint", () => {
				const coordinatesA = new GridPoint(1, 2);
				const coordinatesB = new GridPoint(3, 4);
				const coordinatesC = new GridPoint(5, 6);
				const gridPoints = new GridPoints(
					coordinatesA,
					coordinatesB,
					coordinatesC,
				);
				expect(gridPoints.isContained(new GridPoint(1, 2))).toBe(true);
			});

			it("returns false if Three GridPoints not contains GridPoint", () => {
				const coordinatesA = new GridPoint(1, 2);
				const coordinatesB = new GridPoint(3, 4);
				const coordinatesC = new GridPoint(5, 6);
				const gridPoints = new GridPoints(
					coordinatesA,
					coordinatesB,
					coordinatesC,
				);
				expect(gridPoints.isContained(new GridPoint(4, 5))).toBe(false);
			});
		});
		describe("Four Gridpoints", () => {
			it("throw error", () => {
				const coordinatesA = new GridPoint(1, 2);
				const coordinatesB = new GridPoint(3, 4);
				const coordinatesC = new GridPoint(5, 6);
				const coordinatesD = new GridPoint(7, 8);

				expect(
					() =>
						new GridPoints(
							coordinatesA,
							coordinatesB,
							coordinatesC,
							coordinatesD,
						),
				).toThrow(Error);
			});
		});
	});

	describe("Connected", () => {
		it("returns true if Two GridPoints are connected", () => {
			const coordinatesA = new GridPoint(1, 2);
			const coordinatesB = new GridPoint(1, 3);
			const gridPoints = new GridPoints(coordinatesA, coordinatesB);

			expect(gridPoints.isConnected()).toBe(true);
		});
		it("returns false if Two GridPoints are not connected", () => {
			const coordinatesA = new GridPoint(1, 2);
			const coordinatesB = new GridPoint(3, 4);
			const gridPoints = new GridPoints(coordinatesA, coordinatesB);

			expect(gridPoints.isConnected()).toBe(false);
		});
	});
});

describe("Sample TestCases", () => {
	describe("1", () => {
		it("generates gridpoint", () => {
			const gridPoint = new GridPoint(4, 7);

			expect(gridPoint.x).toBe(4);
			expect(gridPoint.y).toBe(7);
		});

		it("returns notation", () => {
			const gridPoint = new GridPoint(4, 7);

			expect(gridPoint.getNotation()).toBe("(4, 7)");
		});
	});

	describe("2", () => {
		it("return true if two GridPoints have same coordinates", () => {
			const coordinatesA = new GridPoint(4, 7);
			const coordinatesB = new GridPoint(4, 7);

			expect(coordinatesA.hasSomeCoordinates(coordinatesB)).toBe(true);
		});

		it("return false if two GridPoints have different coordinates", () => {
			const coordinatesA = new GridPoint(4, 7);
			const coordinatesB = new GridPoint(3, 8);

			expect(coordinatesA.hasSomeCoordinates(coordinatesB)).toBe(false);
		});
	});

	describe("3", () => {
		const testCase = [
			[new GridPoint(4, 7), new GridPoint(3, 7), true],
			[new GridPoint(4, 7), new GridPoint(3, 8), false],
			[new GridPoint(4, 7), new GridPoint(4, 7), false],
		];
		it.each(testCase)("check if %p is neighbor of %p", (a, b, expected) => {
			expect((a as GridPoint).isNeighbor(b as GridPoint)).toBe(expected);
		});
	});
});
