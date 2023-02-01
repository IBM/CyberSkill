import { useRef } from "react"


export default function Start({ setUsername }) {
    const inputRef = useRef();
    const clickJob =()=>{
        inputRef.current.value && setUsername(inputRef.current.value);

    }
    return (
        <div className="start">

            <input placeholder="Enter Your name" className="startInput" ref={inputRef}/>
            <button className="startButton" onClick={clickJob}>Start</button>
        </div>
    )
}
