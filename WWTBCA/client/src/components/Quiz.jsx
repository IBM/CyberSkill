/* eslint-disable react-hooks/exhaustive-deps */
import { useEffect, useState, createRef } from "react";
import useSound from "use-sound";
import correct from "../assets/correct.mp3"
import incorrect from "../assets/incorrect.mp3"
import Helpers from "./Helpers/Helpers";
export default function Quiz(
    {
    setStop,
    questionNum,
    setQuestionNum,
    setAnswerSelected,
    letsPlay,
    onDone,
    getQuestion,
    questionCount,
    verifyQuestionAnswer,
    getQuestionFiftyFiftyAnswers,
    getExpertAnswer
    }) {
     const [answerLoading, setAnswerLoading] = useState(false);
     const [selectedAnswer, setSelectedAnswer] = useState(null);
     const [className , setClassName] = useState("answer");
     const [correctAnswer] = useSound(correct);
     const [incorrectAnswer] = useSound(incorrect);
     const [question, setQuestion] = useState(null);
     const [nextQuestion, setNextQuestion] = useState(null);
     const [modalOpen, setModalOpen] = useState(false);
    
    useEffect(() => {
        letsPlay();
    }, [letsPlay])

    useEffect(() => {
        getQuestion(questionNum).then(res => {
            if(res){
                setQuestion(res);
            }
        });
    }, []);

    useEffect(() => {
        // question has changed
        if(questionNum +1 <= questionCount && question){
            getQuestion(questionNum + 1).then(res => {
                if(res){
                    setNextQuestion(res);
                }
            });
        }
    }, [ question])

     useEffect(()=>{
        if(questionNum > questionCount){
            onDone();
            return;
        }
        if(nextQuestion){
            setQuestion(nextQuestion);
            setNextQuestion(null);
        }
        else if(question){
            getQuestion(questionNum).then(res => {
                if(res){
                    setQuestion(res);
                }
            });
        }
     },[ questionNum]);

     // Delay function
     const delay = (duration, callback) => {
         setTimeout(()=>{
             callback()
         },duration)
     };
     // Click on question function to check answers
     const clickJob = (a, classname, i) => {
        //a => answer object
        //classname => classname of answer div
        //i => index
        if (!answerLoading && classname !== "answer unclickable") {
            setAnswerLoading(true);
            setSelectedAnswer(a);
            setAnswerSelected(true);
            setClassName("answer active");

            for (let indx = 0; indx < 4; indx++) {
                if (i === indx) {
                    continue;
                }
                unclickable(indx);
            }
            
            verifyQuestionAnswer(question.id, a).then(res => {
                if(res){
                    setClassName(res.correct ? "answer correct" : "answer wrong");
                    delay(3000, ()=>
                    {
                        if(res.correct){
                            correctAnswer();
                            delay(1000, () => {
                                setAnswerLoading(false);
                                setQuestionNum((prev) => prev +1);
                                setAnswerSelected(false);
                                setSelectedAnswer(null);
                                setModalOpen(false);
                             });
                        } else{
                            incorrectAnswer();
                            delay(1000,()=>{
                                setStop(true);
                            })
                          }
                    });
                }
                else{
                    setAnswerLoading(false);
                    setAnswerSelected(false);
                    setSelectedAnswer(null);
                    setModalOpen(false);
                }
            });
            // 
        } else {
            console.log("What do you think you're doing?")
        }
    };

    //make answer not clickable
    const unclickable = (i) => {
        ansRef.current.children[i].className = "answer unclickable";
    }

    const ansRef = createRef();
    
    return (
        question ? (
            <div className="quiz">
                <Helpers
                question={question}
                unclickable={unclickable}
                getQuestionFiftyFiftyAnswers={getQuestionFiftyFiftyAnswers}
                getExpertAnswer={getExpertAnswer}
                modalOpen={modalOpen}
                setModalOpen={setModalOpen}
                />
                <div className="question">{question?.question}</div>
                <div className="answers" ref={ansRef}>
                    {question?.answers.map((a, i) => (
                        <div key={a.replace(/\s/g, '')}
                            className={selectedAnswer === a ? className : "answer"}
                            onClick={() => { clickJob(a, ansRef.current.children[i].className, i) }} >
                            {a}
                        </div>
                    ))}
                </div>
            </div>
        ) : null
    )
}


