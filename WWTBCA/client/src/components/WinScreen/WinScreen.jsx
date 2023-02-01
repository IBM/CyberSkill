import { Button, Modal } from "carbon-components-react";
import { ChevronRight32 } from "@carbon/icons-react";
import React from "react";

const WinScreen = ({ isOpen, showLeaderboard }) => {
  return (
    <Modal
      open={isOpen}
      modalHeading="Congratulations!"
      passiveModal
      size="sm"
      className="game-over"
    >
      <p style={{ marginBottom: "1rem" }}>
        You've reached a level of <strong>Cyber Matrix</strong>. Your cybersecurity knowledge is unmatched!
        See how you stack against other players</p>
      <Button onClick={showLeaderboard} renderIcon={ChevronRight32}>
        Show me the Leaderboard!
      </Button>
    </Modal>
  );
};

export default WinScreen;
