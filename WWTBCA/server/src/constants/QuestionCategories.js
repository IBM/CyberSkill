const Categories = [
  {
    id: "1",
    name: "General Knowledge",
    questions: [
      //level 1
      [
        {
          id: "1",
          question:
            "What is the best way to keep employees from falling for a phishing scam?",
          answers: [
            {
              text: "Spam Filters",
              correct: false,
            },
            {
              text: "Awareness training",
              correct: true,
            },
            {
              text: " Deny List",
              correct: false,
            },
            {
              text: "Change email provider",
              correct: false,
            },
          ],
        },
      ],
      //level 2
      [
        {
          id: "1",
          question: "What is the average timeframe of a CISO on the job?",
          answers: [
            {
              text: "5 Years",
              correct: false,
            },
            {
              text: "1 Year",
              correct: false,
            },
            {
              text: "10 Years",
              correct: false,
            },
            {
              text: "2 Years",
              correct: true,
            },
          ],
        },
      ],
      //level 3
      [
        {
          id: "1",
          question: "A reporter calls asking for comments about your companies’ data breach. What should you do?",
          answers: [
            {
              text: "Tell them you don’t know about any breach",
              correct: false,
            },
            {
              text: "Ask them for their contact details and tell them your external communications team will be in contact",
              correct: true,
            },
            {
              text: "Tell them you are still investigating",
              correct: false,
            },
            {
              text: "Tell them you don’t think any clients have been impacted",
              correct: false,
            },
          ],
        },
      ],
      //level 4
      [
        {
          id: "1",
          question: "Which of these is not a Cyber Crisis management best practice?",
          answers: [
            {
              text: "Cyber Runbook",
              correct: false,
            },
            {
              text: "Leadership Under Pressure – Leader’s Intent",
              correct: false,
            },
            {
              text: "Managed Security Service",
              correct: true,
            },
            {
              text: "Fusion Team full business response",
              correct: false,
            },
          ],
        },
      ],
	   //level 5
      [
        {
          id: "1",
          question: "Which of these is not a Cyber Crisis management best practice?",
          answers: [
            {
              text: "Cyber Runbook",
              correct: false,
            },
            {
              text: "Leadership Under Pressure – Leader’s Intent",
              correct: false,
            },
            {
              text: "Managed Security Service",
              correct: true,
            },
            {
              text: "Fusion Team full business response",
              correct: false,
            },
          ],
        },
      ],
    ],
  },
];

module.exports = Categories;
