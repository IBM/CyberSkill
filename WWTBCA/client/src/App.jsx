/* eslint-disable react-hooks/exhaustive-deps */
import { useEffect, useMemo, useState } from "react";
import "./app.scss";
import CESC from "./assets/cesc_logo.png"
import Quiz from "./components/Quiz";
import Timer from "./components/Timer";
import Start from "./components/Start";
import LeaderBoard from "./components/Leaderboard/Leaderboard";
import useSound from "use-sound";
import play from "./assets/play.mp3";
import WinScreen from "./components/WinScreen/WinScreen";
import { ApiRequestPaths, sendRequest } from "./core/api/WWTBCA_api";

function App() {
  const [username, setUsername] = useState(null);
  const [questionNum, setQuestionNum] = useState(1);
  const [tStop, setStop] = useState(false);
  const [earned, setEarned] = useState("Noob");
  const [answerSelected, setAnswerSelected] = useState(false);
  const [showWinningInfo, setShowWinningInfo] = useState(false);
  const [beginTime, setBeginTime] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [leaderboard, setLeaderboard] = useState([]);
  const [currentPlayerId, setCurrentPlayerId] = useState('');


  useEffect(() => {
    if(username){
      setBeginTime(new Date());
    }
  }, [username])

  useEffect(() => {
    if(tStop){
      setIsLoading(true);
      fetch(`/player`,{
        headers: {'Content-Type': "application/json"},
        method: 'POST',
        body: JSON.stringify({
          name: username,
          rank: earned,
          questions_answered: cyberListArray.find(c => c.value === earned)?.id || 0,
          begin_time: beginTime,
          end_time: new Date(),
        })
      })
        .then((response) => response.json())
        .then((data) => {
          if(data.success){
            const id = data.data.id;
            setCurrentPlayerId(id);
            fetch(`/player/${id}/leaderboard`).then(res => res.json()).then(leaderboard => {
              setIsLoading(false);
              if(leaderboard.success){
                setLeaderboard(leaderboard.data);
              }
            })
          }
        });
    }

  }, [tStop, questionNum, earned, username])

  const cyberListArray = useMemo(() =>
    [
      { id: 1, value: "Cyber Ensign" },
      { id: 2, value: "Jr Cyber Lieutentant" },
      { id: 3, value: "Cyber Lieutentant" },
      { id: 4, value: "Cyber Matrix" }
    ].reverse(),
    []
  );

  useEffect(() => {
    questionNum > 1 && setEarned(cyberListArray.find((m) => m.id === questionNum - 1).value)
  }, [cyberListArray, questionNum])
 useEffect(() => {
    if (questionNum === 5) {
      showLeaderboard()
    }
  }, [questionNum])
  //instantiate music here so can call stop in Leaderboard component 
  const [letsPlay, { stop }] = useSound(play);

  const restart = () => {
    setUsername(null)
    setQuestionNum(1)
    setStop(false)
    setEarned('Noob')
    setAnswerSelected(false)
    stop() //stop tha music
  }

  function showLeaderboard(){
    setShowWinningInfo(false);
    setStop(true);
  }

  function getQuestion(questionNum){
    // TODO: sending static category Id 1, use dynamic category based on init selection
    return sendRequest(ApiRequestPaths.getQuestionByCategory("1", questionNum)).then(res => {
      if(res.success){
        return res.data;
      }
      else{
        alert("An error occured while trying to retrieve question");
      }
      return null;
    });
  }

  function verifyQuestionAnswer(questionId, answer){
    // TODO: sending static category Id 1, use dynamic category based on init selection
    return sendRequest(ApiRequestPaths.submitQuestion("1", questionNum, questionId), {
      method: 'POST',
      body: JSON.stringify({answer})
    }).then(res => {
      if(res.success){
        return res.data
      }
      else{
        alert("An error occured while trying to submit answer");
      }
      return null;
    }); 
  }

  function getQuestionFiftyFiftyAnswers(questionId){
    // TODO: sending static category Id 1, use dynamic category based on init selection
    return sendRequest(ApiRequestPaths.getQuestionFiftyFifty("1", questionNum, questionId)).then(res => {
      if(res.success){
        return res.data
      }
      else{
        alert("An error occured while trying to use 50/50 advantage");
      }
      return null;
    }); 
  }

  function getExpertAnswer(questionId){
    // TODO: sending static category Id 1, use dynamic category based on init selection
    return sendRequest(ApiRequestPaths.getExpertAnswer("1", questionNum, questionId)).then(res => {
      if(res.success){
        return res.data
      }
      else{
        alert("An error occured while trying to use Expert");
      }
      return null;
    }); 
  }

  return (
    <div className="App">
      {username ? (
        <>
          <div className="main">
            {tStop ? (
              <>
                <h1 className="endText">{username} you gained a level of:<strong>{earned}</strong> </h1>
                <LeaderBoard
                  restart={restart}
                  isLoading={isLoading}
                  data={leaderboard}
                  currentPlayerId={currentPlayerId}
                />

              </>
            ) : (
              <>
                {!showWinningInfo && (
        <div className="top">
          <div className="timer">
            <Timer setStop={setStop} questionNum={questionNum} paused={answerSelected || showWinningInfo} />
          </div>
        </div>
       )}
                <div className="bottom">
                  <Quiz
                    setStop={setStop}
                    questionNum={questionNum}
                    setQuestionNum={setQuestionNum}
                    setAnswerSelected={setAnswerSelected}
                    letsPlay={letsPlay}
                    onDone={() => setShowWinningInfo(true)}
                    getQuestion={getQuestion}
                    questionCount={15}
                    verifyQuestionAnswer={verifyQuestionAnswer}
                    getQuestionFiftyFiftyAnswers={getQuestionFiftyFiftyAnswers}
                    getExpertAnswer={getExpertAnswer}
                  />
                </div>
              </>
            )}
          </div>
          <div className="steps">
          <div className="steps-header">
              <img src={CESC} alt=""/>
              <h4>Cyber Range Tech R&amp;D</h4>    
            </div>
            <div>
            
            <ul className="cyberList">
              {cyberListArray.map((c) => (
                <li key={c.id} className={questionNum === c.id ? "cyberListItem active" : "cyberListItem"}>
                  <span className="cyberListItemNumber">{c.id}</span>
                  <span className="cyberListItemValue">{c.value}</span>
                </li>
              ))}
            

            </ul>
            </div>
          </div>
        </>
      ) : <Start setUsername={setUsername} />}
      <WinScreen isOpen={showWinningInfo} showLeaderboard={showLeaderboard} />
    </div>
  );
}

export default App;
