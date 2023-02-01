import { useEffect, useState } from "react";

export default function Timer({ setStop, questionNum, paused }) {
    const [timer, setTimer] = useState(10);

    useEffect(()=>{
        if(paused) return;
        if (timer === 0) return setStop(true);
        const interval = setInterval(() => {
    setTimer((prev) => prev -1);    
        }, 1000);
        return () => {
            clearInterval(interval)
        };
    },[setStop, timer, paused]);

    useEffect(() => {
        setTimer(600);
    }, [questionNum])
    return timer;
      
    
};
