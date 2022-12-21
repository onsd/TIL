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
	public coordinates: GridPoint[];
	constructor(...coordinates: GridPoint[]) {
		this.coordinates = coordinates;
	}

	public isContained(other: GridPoint): boolean {
		return this.coordinates.map((c) => c.equals(other)).some((c) => c === true);
	}
	
	public isConnected(): boolean {
		// FIXME: reduce computational complexity: O(n^2)
		return this.coordinates
			.map((c) =>
				this.coordinates
					.map((cc) => c.isNeighbor(cc))
					.some((c) => c === true),
			)
			.every((c) => c === true);
	}

	public isTraversable(): boolean {	
		const list = this.coordinates.concat()

		for (let index = 0; index < list.length; index++) {
			const root = list.shift();
			if (this.traverse(root!, list)){
				return true
			}
			list.push(root!)
		}

		return false
	}	

	private traverse(root: GridPoint, list: GridPoint[]):boolean {
		if(list.length === 0) {
			return true
		}

		var flag = false
		// リストから一つ取り出す
		while(list.length){
			const next = list.shift();
			if (next == undefined) {
				break
			}
			if (!root.isNeighbor(next)){
				continue
			}
			if (this.traverse(next, list)) {
				flag = true
			}
		}
		return flag
	}
}
