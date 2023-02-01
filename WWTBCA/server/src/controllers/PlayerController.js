const wwtbca_db = require("../db");
const BaseError = require("../constants/errors/BaseError");
const LoggerUtil = require("../utils/LoggerUtil");

const logger = require("../config/winston");

const getAllPlayersFromDb = async () => {
  return wwtbca_db.view("list", "players").then((body) => {
    let rows = body.rows;
    return rows.map((player) => player.value);
  });
};

//
// POST /player
//
const storePlayer = async (req, res) => {
  logger.info(
    `[storePlayer] - Accessing storePlayer from ip ${
      req.ip
    }. Request Data is: ${JSON.stringify(req.body)}`
  );
  const { name, rank, questions_answered, begin_time, end_time } = req.body;

  const dbPlayer = {
    name,
    rank,
    questions_answered,
    begin_time,
    end_time,
  };

  wwtbca_db
    .insert(dbPlayer)
    .then((body) => {
      const resObj = {
        success: true,
        data: { id: body.id },
      };
      logger.info(
        `[storePlayer] - Returning Data From storePlayer, ResData is: ${JSON.stringify(
          resObj
        )}`
      );
      res.json(resObj);
    })
    .catch((err) => {
      LoggerUtil.logError(req, err, "storePlayer");
      throw new BaseError("could not save player information at this time");
    });
};

//
// GET /player/:id/leaderboard
//
const getTopPlayers = async (req, res) => {
  logger.info(
    `[getTopPlayers] - Accessing getTopPlayers from ip ${
      req.ip
    }. Request Data is: ${JSON.stringify(req.body)}`
  );
  const { id } = req.params;
  const players = await getAllPlayersFromDb().catch((err) => {
    LoggerUtil.logError(req, err, "getTopPlayers");
    throw new BaseError("Could not retrieve list of players at this time");
  });

  logger.info(`[getTopPlayers] - Obtained list of players from DB`);

  function getGameDuration(time1, time2) {
    return new Date(time2).getTime() - new Date(time1).getTime();
  }

  function sortPlayers(ob1, ob2) {
    if (ob1.questions_answered < ob2.questions_answered) {
      return 1;
    } else if (ob1.questions_answered > ob2.questions_answered) {
      return -1;
    }

    // Else go to the 2nd item
    if (
      getGameDuration(ob1.begin_time, ob1.end_time) <
      getGameDuration(ob2.begin_time, ob2.end_time)
    ) {
      return -1;
    } else if (
      getGameDuration(ob1.begin_time, ob1.end_time) >
      getGameDuration(ob2.begin_time, ob2.end_time)
    ) {
      return 1;
    } else {
      // nothing to split them
      return 0;
    }
  }

  players.sort(sortPlayers);

  let currentPosition = 1;
  let prevPlayer;

  players.forEach((player) => {
    if (prevPlayer) {
      if (
        player.questions_answered === prevPlayer.questions_answered &&
        getGameDuration(player.begin_time, player.end_time) ===
          getGameDuration(prevPlayer.begin_time, prevPlayer.end_time)
      ) {
        player.position = currentPosition;
      } else {
        player.position = ++currentPosition;
      }
    } else {
      player.position = 1;
    }
    prevPlayer = player;
  });

  let topPlayers = players.slice(0, 10);

  const currentPlayerIndex = players.findIndex((p) => p._id === id);

  if (currentPlayerIndex > 9) {
    topPlayers.push(players[currentPlayerIndex]);
  }

  logger.info("[getTopPlayers] - returning data succesfully");
  res.json({
    success: true,
    data: topPlayers.map((p) => {
      return {
        id: p._id,
        name: p.name,
        rank: p.rank,
        questions_answered: p.questions_answered,
        begin_time: p.begin_time,
        end_time: p.end_time,
        position: p.position,
      };
    }),
  });
};

module.exports = {
  storePlayer,
  getTopPlayers,
};
