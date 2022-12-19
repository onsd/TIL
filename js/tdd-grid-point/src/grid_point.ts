
export class GridPoint {
    constructor(public x: number, public y: number) {}

    public equals(other: GridPoint): boolean {
        return this.x === other.x && this.y === other.y;
    }

    public getNotation(): string {
        return `(${this.x}, ${this.y})`;
    }
}
