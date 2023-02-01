const ApiRequestPaths = {
  categories: () => "/categories",
  getQuestionByCategory: (categoryId, questionLevel) => `/categories/${categoryId}/questions/${questionLevel}`,
  submitQuestion: (categoryId, questionLevel, questionId) => `/categories/${categoryId}/questions/${questionLevel}/${questionId}`,
  getQuestionFiftyFifty: (categoryId, questionLevel, questionId) => `/categories/${categoryId}/questions/${questionLevel}/${questionId}/fiftyfifty`,
  getExpertAnswer: (categoryId, questionLevel, questionId) => `/categories/${categoryId}/questions/${questionLevel}/${questionId}/expert`
};

function execRequest(
  relativePath,
  opts = {},
  omitHeaders = false
) {
  const options = {
    ...opts,
  };
  const headers = new Headers(options.headers);
  if (!headers.get("Content-Type") && !omitHeaders) {
    headers.append("Content-Type", "application/json");
    if (typeof options.body === "object") {
      options.body = JSON.stringify(options.body);
    }
  }
  return fetch(
    `${relativePath}`,
    {
      headers,
      ...options,
    }
  );
}

function sendRequest(
  relativePath,
  opts = {},
  omitHeaders = false
) {
  return execRequest(relativePath, opts, omitHeaders).then(
    async (fetchResult) => {
      return fetchResult.json().then((data) => {
        return {
          success: data.success,
          data: data?.data,
          error: data.success
            ? undefined
            : { code: data.code, message: data.msg },
        };
      });
    }
  );
}

export { ApiRequestPaths, sendRequest };
