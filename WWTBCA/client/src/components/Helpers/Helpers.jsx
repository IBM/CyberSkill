import { useState } from "react";
import expert from "../../assets/expert.png";
import { GaugeChart } from "@carbon/charts-react";

function Helpers({
    question,
    unclickable,
    getQuestionFiftyFiftyAnswers,
    getExpertAnswer,
    modalOpen,
    setModalOpen,
}) {
    const [fiftyUsed, setFiftyUsed] = useState(false);
    

    const [expertUsed, setExpertUsed] = useState(false);
    const [expertConf, setExpertConf] = useState(0);
    const [expertAns, setExpertAns] = useState("");

    const fiftyFifty = () => {
        if (!fiftyUsed) {
            setFiftyUsed(true);
            getQuestionFiftyFiftyAnswers(question.id).then(res => {
                if (res) {
                    const deletedAnswers = question.answers.filter(ans => !res.includes(ans));
                    unclickable(question.answers.indexOf(deletedAnswers[0]));
                    unclickable(question.answers.indexOf(deletedAnswers[1]));
                }
                else {
                    setFiftyUsed(false);
                }
            });
        }
    }

    const askExpert = () => {
        if (!expertUsed) {
            setExpertUsed(true);
            setModalOpen(true);
            getExpertAnswer(question.id).then(res => {
                setExpertConf(res.confidence);
                setExpertAns(res.answer);
            }).catch(e => alert(e))
        }

    }

    return (

        <>
            <div className={modalOpen ? "helper-content in-focus" : "helper-content"}>
                {expertUsed ? (
                    <>
                    <div className="expert in-focus">
                        <div  className="expert-ans">
                            <p>Expert thinks the answer is...</p>
                            <h3>{expertAns}</h3>
                        </div>

                        <GaugeChart
                            data={[
                                {
                                    "group": "value",
                                    "value": Math.round(expertConf * 100)
                                }
                            ]}
                            options={{
                                "title": "Confidence Level",
                                "resizable": true,
                                "height": "125px",
                                "gauge": {
                                    "type": "semi"
                                },
                                "color": {
                                    "scale": {
                                        "value": "#706EC6;"
                                    }
                                }
                            }}></GaugeChart>
                    </div>
                    </>
                      ) : (
                        <div>
                            <p>watson stuff</p>
                        </div>
                      )}
                
            </div>

            <div className="helpers">
                <div className={fiftyUsed ? "helper used" : "helper"}
                    onClick={() => fiftyFifty()}
                >
                    <p>50:50</p>
                </div>

                <div className={expertUsed ? "helper used" : "helper"}
                    onClick={() => askExpert()}
                >
                    <img className="expert-img" src={expert} alt="ask the expert" />
                </div>
            </div>
        </>

    )
}

export default Helpers