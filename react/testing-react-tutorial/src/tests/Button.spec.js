import React from "react";
import { create } from "react-test-renderer"

const Button = (props) => {
    return <Button>Nothing to do for now</Button>
}

describe("Button component", () => {
    test("Matches the snapshot", () => {
        const button = create(<Button />);
        expect(button.toJSON()).toMatchSnapshot();
    });
});