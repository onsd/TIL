export class GridPoint {
	constructor(public x: number, public y: number) {}

	public equals(other: GridPoint): boolean {
		return this.x === other.x && this.y === other.y;
	}

	public getNotation(): string {
		return `(${this.x}, ${this.y})`;
	}

	public hasSomeCoordinates(coordinatesB: GridPoint): boolean {
		return this.x === coordinatesB.x && this.y === coordinatesB.y;
	}

	public isNeighbor(other: GridPoint): boolean {
		return (
			(this.x === other.x && Math.abs(this.y - other.y) === 1) ||
			(this.y === other.y && Math.abs(this.x - other.x) === 1)
		);
	}
}

export class GridPoints {
	constructor(public a: GridPoint, public b: GridPoint) {}
	public isContained(other: GridPoint): boolean {
		return this.a.equals(other) || this.b.equals(other);
	}
	public isConnected(): boolean {
		return this.a.isNeighbor(this.b);
	}
}